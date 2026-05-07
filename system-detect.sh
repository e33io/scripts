#!/usr/bin/env bash

# =============================================================================
# System type and HiDPI detection for modifying window manager configs
# URL: https://github.com/e33io/scripts/blob/main/system-detect.sh
# =============================================================================

set -euo pipefail

# Use C locale to avoid comma decimal separators in awk/printf
export LC_ALL=C

# Detect device type
pc_type="$(hostnamectl chassis)"

if [ "$pc_type" != "vm" ]; then
    # Find the first connected display
    display_line=$(xrandr --query | grep ' connected' | head -1)
    res_field=$(echo "$display_line" | grep -oE '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+' | head -1)
    width_px=$(echo "$res_field" | sed 's/x.*//')
    height_px=$(echo "$res_field" | sed 's/[0-9]*x//' | sed 's/+.*//')
    width_mm=$(echo "$display_line" | grep -oE '[0-9]+mm x [0-9]+mm' | sed 's/mm.*//')
    height_mm=$(echo "$display_line" | grep -oE '[0-9]+mm x [0-9]+mm' | sed 's/.*x //' | sed 's/mm//')
    display_info="${width_px} ${height_px} ${width_mm:-0} ${height_mm:-0}"

    # Parse info safely
    if [ -z "$width_px" ] || [ -z "$height_px" ]; then
        echo "! Could not parse display info from xrandr."
        xrandr --query
        exit 1
    fi

    # Handle missing physical size (assumes 96 DPI as fallback - may not reflect
    # actual screen size on high-density or unusual displays)
    if [ "$width_mm" = "0" ] || [ -z "$width_mm" ]; then
        width_mm=$(awk -v px="$width_px" 'BEGIN { print int((px/96)*25.4) }')
        height_mm=$(awk -v px="$height_px" 'BEGIN { print int((px/96)*25.4) }')
        note="(estimated physical size)"
    else
        note=""
    fi

    diag_in=$(awk -v w="$width_mm" -v h="$height_mm" 'BEGIN { print sqrt(w*w + h*h)/25.4 }')
    diag_in_fmt=$(awk -v d="$diag_in" 'BEGIN { printf "%.1f", d }')

    # Determine if HiDPI
    is_hidpi=false
    case "$pc_type" in
        laptop|portable|notebook|convertible|tablet)
            awk -v d="$diag_in" -v w="$width_px" \
                'BEGIN { exit !((d > 13.5 && w > 2256) || (d < 12.8 && w >= 1920)) }' && is_hidpi=true || true
            ;;
        *)
            awk -v d="$diag_in" -v w="$width_px" \
                'BEGIN { exit !(d > 25 && w > 1920) }' && is_hidpi=true || true
            ;;
    esac

    # Device and display info output
    echo "========================================================================"
    printf "Device type: %s\n" "$pc_type"
    printf "Resolution: %sx%s\n" "$width_px" "$height_px"
    printf "Physical size: ~%s\" %s\n" "$diag_in_fmt" "${note:-}"
    printf "HiDPI: %s\n" "$is_hidpi"
    echo "========================================================================"
    sleep 1
fi

# Run setup scripts
if [ "$pc_type" = "vm" ]; then
    clear
    while true; do
        echo "========================================================================"
        echo "The option below lets you select a configuration specific"
        echo "to your monitor type for proper display scaling."
        echo "========================================================================"
        echo "  1) Standard HD (96 dpi settings for 1x scaling)"
        echo "  2) HiDPI (192 dpi settings for 2x scaling)"
        echo "------------------------------------------------------------------------"
        read -rp "What type of monitor are you using? " n
        case $n in
            1) echo "You chose Standard HD (96 dpi) monitor"
               bash ~/scripts/mod-wm-dpi-scaling.sh
               break;;
            2) echo "You chose HiDPI (192 dpi) monitor"
               break;;
            *) echo "Invalid selection, please enter a number from the list.";;
        esac
    done
elif [ "${is_hidpi:-false}" = "false" ]; then
    echo "Standard HD (~96 dpi) monitor detected - updating configuration..."
    bash ~/scripts/mod-wm-dpi-scaling.sh
fi

case "$pc_type" in
    laptop|portable|notebook|convertible|tablet)
        echo "Laptop/notebook device-type detected - updating configuration..."
        bash ~/scripts/mod-wm-laptop.sh
        ;;
    vm)
        echo "VM device-type detected - updating configuration..."
        bash ~/scripts/mod-virt-machines.sh
        ;;
    *) echo "Desktop device-type detected - no additional updates.";;
esac
