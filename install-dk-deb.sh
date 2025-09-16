#!/bin/bash

# =============================================================================
# Install dk from source on Debian
# URL: https://github.com/e33io/scripts/blob/main/install-dk-deb.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

echo "========================================================================"
echo "Install dependencies"
echo "========================================================================"

sudo apt -y install build-essential pkg-config libbsd-dev libfontconfig1-dev \
libx11-xcb-dev libxcb-cursor-dev libxcb-icccm4-dev libxcb-keysyms1-dev \
libxcb-randr0-dev libxcb-res0-dev libxcb-util-dev libxcb-xinput-dev \
libxcb-xtest0-dev libxcb1-dev libxcursor-dev libxft-dev libxinerama-dev \
xserver-xorg x11-utils suckless-tools sxhkd

echo "========================================================================"
echo "Clone dk repository"
echo "========================================================================"

git clone https://github.com/natemaia/dk $HOME/dk
cd $HOME/dk

echo "========================================================================"
echo "Build and install dk"
echo "========================================================================"

make
sudo make install
cd
rm -rf $HOME/dk

echo "========================================================================"
echo "Add dk.desktop file"
echo "========================================================================"

printf "%s\n" "[Desktop Entry]" "Encoding=UTF-8" "Type=Application" \
"Name=dk" "Comment=a dynamic tiling window manager" "TryExec=dk" \
"Exec=dk" "NoDisplay=false" "Hidden=false" "StartupNotify=false" \
"DesktopNames=dk" "X-LightDM-DesktopName=dk" \
"Keywords=tiling;window;manager;wm;windowmanager;" " " "[Window Manager]" \
"Name=dk" "SessionManaged=true" "StartupNotification=false" \
| sudo tee /usr/share/xsessions/dk.desktop > /dev/null

echo "========================================================================"
echo "dk is now installed"
echo "========================================================================"
