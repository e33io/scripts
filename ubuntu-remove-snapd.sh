#!/bin/bash

# =============================================================================
# Ubuntu Linux - Remove Snaps, Disable Snapd and Install Flatpak
# URL: https://github.com/e33io/scripts/blob/main/ubuntu-remove-snapd.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: The system will automatically reboot at the end of script.
# =============================================================================

set -euo pipefail

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
echo "Remove snaps, disable snapd, then de-prioritize snapd"
echo "packages to avoid snap(s) installation"
echo "========================================================================"

if command -v snap >/dev/null 2>&1; then
    snap list | awk 'NR>1 {print $1}' | grep -Ev '^(bare|core[0-9]*|snapd)$' | while read -r snap; do
        sudo snap remove --purge "$snap"
    done
    snap list | awk 'NR>1 {print $1}' | grep -E '^(bare|core[0-9]*|snapd)$' | while read -r snap; do
        sudo snap remove --purge "$snap"
    done
fi

sudo systemctl stop snapd.service snapd.socket snapd.seeded.service 2>/dev/null || true
sudo systemctl disable snapd.service snapd.socket snapd.seeded.service 2>/dev/null || true
sudo systemctl mask snapd.service snapd.socket 2>/dev/null || true

sudo apt -y purge snapd
sudo apt -y autoremove --purge
sudo apt -y autoclean

sudo rm -rf /snap /var/snap /var/lib/snapd
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
