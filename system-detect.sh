#!/usr/bin/env bash

# =============================================================================
# System type and HiDPI detection for X11
# =============================================================================

set -euo pipefail

# Use C locale to avoid comma decimal separators in awk/printf
export LC_ALL=C

# Find the first connected display with a resolution
display_info=$(xrandr --query | awk '
/ connected/ {
    if (match($0, /([0-9]+)x([0-9]+)/, res)) {
        width_px = res[1]; height_px = res[2];
    }
    if (match($0, /([0-9]+)mm x ([0-9]+)mm/, dim)) {
        width_mm = dim[1]; height_mm = dim[2];
    }
    if (width_px && height_px) {
        print width_px, height_px, (width_mm?width_mm:0), (height_mm?height_mm:0);
        exit;
    }
}')

# Parse info safely
if [ -z "$display_info" ]; then
    echo "! Could not parse display info from xrandr."
    xrandr --query
    exit 1
fi

read -r width_px height_px width_mm height_mm <<<"$display_info"

# Handle missing physical size (assumes 96 DPI as fallback — may not reflect
# actual screen size on high-density or unusual displays)
if [ "$width_mm" = "0" ] || [ -z "$width_mm" ]; then
    width_mm=$(awk -v px="$width_px" 'BEGIN { print int((px/96)*25.4) }')
    height_mm=$(awk -v px="$height_px" 'BEGIN { print int((px/96)*25.4) }')
    note="(estimated physical size)"
else
    note=""
fi

# Compute diagonal in inches
diag_in=$(awk -v w="$width_mm" -v h="$height_mm" 'BEGIN { print sqrt(w*w + h*h)/25.4 }')

# Detect device type
if command -v hostnamectl > /dev/null 2>&1; then
    pc_type=$(hostnamectl 2>/dev/null | grep -i "Chassis" | awk '{print tolower($2)}')
else
    sys_vendor="$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null || echo '')"
    # Check for laptop-detect tool before using it
    if command -v laptop-detect > /dev/null 2>&1 && laptop-detect > /dev/null 2>&1; then
        pc_type="laptop"
    elif [ "$sys_vendor" = "QEMU" ]; then
        pc_type="vm"
    else
        pc_type="desktop"
    fi
fi

# Determine if HiDPI
is_hidpi=false
case "$pc_type" in
    laptop|portable|notebook|convertible|tablet)
        awk -v d="$diag_in" -v w="$width_px" \
            'BEGIN { exit !(d > 13.5 && w > 2256) }' && is_hidpi=true || true
        ;;
    vm)
        awk -v d="$diag_in" -v w="$width_px" \
            'BEGIN { exit !(d > 15 && w > 1920) }' && is_hidpi=true || true
        ;;
    *)
        awk -v d="$diag_in" -v w="$width_px" \
            'BEGIN { exit !(d > 25 && w > 1920) }' && is_hidpi=true || true
        ;;
esac

# Output
echo "========================================================================"
printf "Device type: %s\n" "$pc_type"
printf "Resolution: %sx%s\n" "$width_px" "$height_px"
printf "Physical size: ~%.1f\" %s\n" "$diag_in" "$note"
printf "HiDPI: %s\n" "$is_hidpi"
echo "========================================================================"

if [ "$is_hidpi" = "false" ]; then
    echo "========================================================================"
    echo "Modify window manager configs for standard HD monitors"
    echo "========================================================================"
    bash mod-wm-dpi-scaling.sh
fi

case "$pc_type" in
    laptop|portable|notebook|convertible|tablet)
        echo "========================================================================"
        echo "Modify window manager configs for laptop/notebook use"
        echo "========================================================================"
        bash mod-wm-laptop.sh
        ;;
    vm)
        echo "========================================================================"
        echo "Install spice-vdagent and modify VM-specific configs"
        echo "========================================================================"
        bash mod-virt-machines.sh
        ;;
esac
