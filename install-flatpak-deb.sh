#!/bin/bash

# =============================================================================
# Install Flatpak package and add Flathub repository on Debian/Ubuntu
# URL: https://github.com/e33io/scripts/blob/main/install-flatpak-deb.sh
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
echo "Update and upgrade system"
echo "========================================================================"

sudo apt update
sudo apt -y upgrade

echo "========================================================================"
echo "Install Flatpak package and add Flathub repository"
echo "========================================================================"

sudo apt -y install flatpak

if command -v gnome-shell > /dev/null 2>&1 \
    || command -v gnome-software > /dev/null 2>&1; then
    sudo apt -y install gnome-software-plugin-flatpak
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

if command -v gnome-software > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Add org.gnome.Software.desktop file to manually"
    echo "start Gnome Software (disable autostart)"
    echo "========================================================================"

    mkdir -p ~/.config/autostart
    cp -R /etc/xdg/autostart/org.gnome.Software.desktop ~/.config/autostart
    echo "X-GNOME-Autostart-enabled=false" \
    | tee -a ~/.config/autostart/org.gnome.Software.desktop > /dev/null
fi

echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
