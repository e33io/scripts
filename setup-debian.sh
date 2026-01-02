#!/bin/bash

# =============================================================================
# Debian 13 Trixie or Devuan 6 Excalibur Initial Setup
# URL: https://github.com/e33io/scripts/blob/main/setup-debian.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh setup-debian.sh
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
echo "Run console-setup to set TTY font and font size"
echo "========================================================================"

sudo dpkg-reconfigure console-setup
clear

# get Debian or Devuan release name
os_codename="$(lsb_release -a | awk '/Codename:/ { print $2 }')"

echo "========================================================================"
echo "Update the apt sources.list file"
echo "========================================================================"

if [ "$os_codename" = trixie ]; then
echo "# Reference: https://wiki.debian.org/SourcesList

deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian trixie main contrib non-free non-free-firmware

deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware

deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware

deb http://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware" \
| sudo tee /etc/apt/sources.list > /dev/null
elif [ "$os_codename" = excalibur ]; then
echo "# Reference: https://www.devuan.org/os/packages

deb http://deb.devuan.org/merged excalibur main contrib non-free non-free-firmware
deb-src http://deb.devuan.org/merged excalibur main contrib non-free non-free-firmware

deb http://deb.devuan.org/merged excalibur-security main non-free-firmware
deb-src http://deb.devuan.org/merged excalibur-security main non-free-firmware

deb http://deb.devuan.org/merged excalibur-updates main contrib non-free non-free-firmware
deb-src http://deb.devuan.org/merged excalibur-updates main contrib non-free non-free-firmware

deb http://deb.devuan.org/merged excalibur-backports main contrib non-free non-free-firmware
deb-src http://deb.devuan.org/merged excalibur-backports main contrib non-free non-free-firmware" \
| sudo tee /etc/apt/sources.list > /dev/null
fi

echo "========================================================================"
echo "Update and upgrade system"
echo "========================================================================"

sudo apt update
sudo apt -y upgrade
sudo apt -y full-upgrade

echo "========================================================================"
echo "Install additional firmware packages"
echo "========================================================================"

sudo apt -y install firmware-linux firmware-linux-nonfree

echo "========================================================================"
echo "Make and setup a swap file"
echo "========================================================================"

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

echo "========================================================================"
echo "Option to install the backports kernel for newer hardware"
echo "========================================================================"

while true; do
    read -rp "Do you want to install the backports kernel? (y/n) " yn
    case $yn in
        [Yy]* ) sudo apt -t "${os_codename}"-backports -y install linux-image-amd64;
                break;;
        [Nn]* ) echo "You chose NOT to install the backports kernel";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "========================================================================"
echo "Remove and clean up unneeded packages"
echo "========================================================================"

sudo apt -y autoremove
sudo apt -y autoclean

echo "========================================================================"
echo "Initial setup is done."
echo "========================================================================"
