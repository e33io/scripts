#!/bin/bash

# =============================================================================
# Setup TearFree for Intel GPUs
# URL: https://github.com/e33io/scripts/blob/main/setup-tearfree-intel.sh
# -----------------------------------------------------------------------------
# Only use on X11 systems with Intel GPUs
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! Do not run this script as root!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

# install Intel packages
sudo pacman -S --noconfirm --needed mesa-utils xf86-video-intel

# setup TearFree option
device="$(glxinfo -B | awk '/Vendor:/ { print $2 }')"
if [ "$device" = Intel ]; then
    echo 'Section "Device"
    Identifier "Intel Graphics"
    Driver     "intel"
    Option     "TearFree" "true"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf > /dev/null
    echo "Intel graphics TearFree is now active."
else
    echo "Intel graphics device does not exist,"
    echo "no changes were made to the system."
fi
