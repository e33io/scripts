#!/bin/bash

# =============================================================================
# Install spectrwm from source on Debian
# URL: https://github.com/e33io/scripts/blob/main/install-spectrwm-deb.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

echo "========================================================================"
echo "Install dependencies"
echo "========================================================================"

sudo apt -y install build-essential pkg-config libxcb1-dev libxcb-util-dev \
libxcb-randr0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-xinput-dev \
libxcb-xtest0-dev libfontconfig1-dev libxft-dev libxcursor-dev libbsd-dev \
libx11-xcb-dev xorg xserver-xorg suckless-tools
sudo apt -y build-dep spectrwm

echo "========================================================================"
echo "Clone spectrwm repository"
echo "========================================================================"

git clone https://github.com/conformal/spectrwm $HOME/spectrwm
cd $HOME/spectrwm/linux

echo "========================================================================"
echo "Build and install spectrwm"
echo "========================================================================"

make
sudo make install
cd
rm -rf $HOME/spectrwm

echo "========================================================================"
echo "Add spectrwm.desktop file"
echo "========================================================================"

printf "%s\n" "[Desktop Entry]" "Encoding=UTF-8" "Type=Application" \
"Name=spectrwm" "Comment=a dynamic tiling window manager" "TryExec=spectrwm" \
"Exec=spectrwm" "NoDisplay=false" "Hidden=false" "StartupNotify=false" \
"DesktopNames=spectrwm" "X-LightDM-DesktopName=spectrwm" \
"Keywords=tiling;window;manager;wm;windowmanager;" " " "[Window Manager]" \
"Name=spectrwm" "SessionManaged=true" "StartupNotification=false" \
| sudo tee /usr/share/xsessions/spectrwm.desktop > /dev/null

echo "========================================================================"
echo "spectrwm is now installed"
echo "========================================================================"
