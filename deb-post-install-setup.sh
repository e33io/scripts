#!/bin/bash

# ==============================================================================
# Debian 12 Bookworm (post-install) Initial Setup
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-setup.sh
# ------------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# ==============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Run console-setup to set TTY font and font size"
echo "#########################################################"

sudo dpkg-reconfigure console-setup
clear

echo "#########################################################"
echo "Update Debian Bookworm apt sources.list file"
echo "#########################################################"

echo "# Please see https://wiki.debian.org/SourcesList for a complete reference!

deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware

deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware

deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" \
| sudo tee /etc/apt/sources.list > /dev/null

echo "#########################################################"
echo "Update and upgrade system"
echo "#########################################################"

sudo apt update
sudo apt -y upgrade
sudo apt -y full-upgrade

echo "#########################################################"
echo "Install additional firmware packages"
echo "#########################################################"

sudo apt -y install firmware-linux firmware-linux-nonfree

echo "#########################################################"
echo "Make and setup a swap file"
echo "#########################################################"

if free | awk '/^Swap:/ { exit !$2 }'; then
    echo "Swap file/partition already exists,"
    echo "no changes were made to the system."
else
    # Edit the "2G" to a different size if needed
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    printf "# swap file\n/swapfile swap swap defaults 0 0" | \
    sudo tee -a /etc/fstab > /dev/null
    # Edit the swappiness value if needed
    echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf > /dev/null
    echo "Swap file was added to the system."
fi

echo "#########################################################"

while true; do
    read -p "Do you want to install the backports kernel? (y/n) " yn
    case $yn in
        [Yy]* ) sudo apt -t bookworm-backports -y install linux-image-amd64;
                break;;
        [Nn]* ) echo "You chose NOT to install the backports kernel";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "#########################################################"
echo "Remove and clean up unneeded packages"
echo "#########################################################"

sudo apt -y autoremove
sudo apt -y autoclean

echo "#########################################################"
echo "Initial setup is done."
echo "#########################################################"
