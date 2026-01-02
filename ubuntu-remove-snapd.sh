#!/bin/bash

# =============================================================================
# Ubuntu Linux - Remove Snaps, Disable Snapd and Install Flatpak
# URL: https://github.com/e33io/scripts/blob/main/ubuntu-remove-snapd.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: The system will automatically reboot at the end of script.
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
echo "Disable and remove snapd, then de-prioritize snapd"
echo "packages to avoid snap(s) installation"
echo "========================================================================"

if [ -d /snap/firefox ]; then
    sudo snap remove firefox
fi

if [ -d /snap/firmware-updater ]; then
    sudo snap remove firmware-updater
fi

if [ -d /snap/desktop-security-center ]; then
    sudo snap remove desktop-security-center
fi

if [ -d /snap/prompting-client ]; then
    sudo snap remove prompting-client
fi

if [ -d /snap/gnome-42-2204 ]; then
    sudo snap remove gnome-42-2204
fi

if [ -d /snap/gtk-common-themes ]; then
    sudo snap remove gtk-common-themes
fi

if [ -d /snap/snap-store ]; then
    sudo snap remove snap-store
fi

if [ -d /snap/snapd-desktop-integration ]; then
    sudo snap remove snapd-desktop-integration
fi

if [ -d /snap/bare ]; then
    sudo snap remove bare
fi

if [ -d /snap/core22 ]; then
    sudo snap remove core22
fi

if [ -d /snap/snapd ]; then
    sudo snap remove snapd
fi

sudo systemctl stop snapd.service
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket

sudo apt -y purge snapd
sudo apt -y autoremove
sudo apt -y autoclean

rm -rf ~/snap

echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref > /dev/null

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
echo "Revert fonts to classic Ubuntu fonts and reboot system"
echo "========================================================================"

sudo apt -y install fonts-ubuntu-classic fonts-ubuntu-console
fc-cache -f

if command -v gnome-shell > /dev/null 2>&1; then
    dconf write /org/gnome/desktop/interface/font-name "'Ubuntu 11'"
    dconf write /org/gnome/desktop/interface/monospace-font-name "'Ubuntu Mono 13'"
fi

reboot
