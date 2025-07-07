#!/bin/bash

# ======================================================================
# Ubuntu Remove Snaps, Disable Snapd and Optionally Install Flatpak
# URL: https://github.com/e33io/scripts/blob/main/ubuntu-remove-snapd.sh
# ----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# ======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Update and upgrade system"
echo "################################################################"

sudo apt update
sudo apt -y upgrade

echo "################################################################"
echo "Disable and remove snapd, then de-prioritize snapd"
echo "packages to avoid snap(s) installation"
echo "################################################################"

if [ -d "/snap/firefox" ]; then
    sudo snap remove firefox
fi

if [ -d "/snap/firmware-updater" ]; then
    sudo snap remove firmware-updater
fi

if [ -d "/snap/desktop-security-center" ]; then
    sudo snap remove desktop-security-center
fi

if [ -d "/snap/prompting-client" ]; then
    sudo snap remove prompting-client
fi

if [ -d "/snap/gnome-42-2204" ]; then
    sudo snap remove gnome-42-2204
fi

if [ -d "/snap/gtk-common-themes" ]; then
    sudo snap remove gtk-common-themes
fi

if [ -d "/snap/snap-store" ]; then
    sudo snap remove snap-store
fi

if [ -d "/snap/snapd-desktop-integration" ]; then
    sudo snap remove snapd-desktop-integration
fi

if [ -d "/snap/bare" ]; then
    sudo snap remove bare
fi

if [ -d "/snap/core22" ]; then
    sudo snap remove core22
fi

if [ -d "/snap/snapd" ]; then
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

echo "################################################################"
echo "Flatpak package and Flathub repository option"
echo "----------------------------------------------------------------"

while true; do
    read -p "Do you want to install Flatpak and add Flathub repository (y/n) " yn
    case $yn in
        [Yy]* ) sudo apt -y install flatpak;
                if { [ -f "/bin/gnome-shell" ] || [ -f "/bin/gnome-software" ]; }; then
                    sudo apt -y install gnome-software-plugin-flatpak
                fi
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;
                break;;
        [Nn]* ) echo "You chose to NOT install Flatpak and add Flathub repository";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

if [ -f "/bin/gnome-software" ]; then
    echo "################################################################"
    echo "Add org.gnome.Software.desktop file to manually"
    echo "start Gnome Software (disable autostart)"
    echo "################################################################"

    mkdir -p $HOME/.config/autostart
    echo "X-GNOME-Autostart-enabled=false" > $HOME/.config/autostart/org.gnome.Software.desktop
fi

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
