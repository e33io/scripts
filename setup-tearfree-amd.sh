#!/bin/bash

# =============================================================================
# Setup TearFree for AMD GPUs
# URL: https://github.com/e33io/scripts/blob/main/setup-tearfree-amd.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Only use on X11 systems with AMD GPUs
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

if [ -f /etc/debian_version ]; then
    sudo apt -y install xserver-xorg-video-amdgpu
fi
if [ -f /etc/pacman.conf ]; then
    sudo pacman -S --noconfirm --needed mesa-utils xf86-video-amdgpu
fi

device="$(glxinfo -B | awk '/Vendor:/ { print $2 }')"
if [ "$device" = AMD ]; then
    echo 'Section "Device"
    Identifier "AMD Graphics"
    Driver     "amdgpu"
    Option     "TearFree" "true"
EndSection' | sudo tee /etc/X11/xorg.conf.d/20-amdgpu.conf > /dev/null
    echo "AMD graphics TearFree is now active."
else
    echo "AMD graphics device does not exist,"
    echo "no changes were made to the system."
fi
