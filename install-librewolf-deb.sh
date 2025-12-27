#!/bin/bash

# =============================================================================
# Install LibreWolf Web Browser from LibreWolf's .deb package repos
# URL: https://github.com/e33io/scripts/blob/main/install-librewolf-deb.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Please see https://librewolf.net for a complete reference
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
echo "Install LibreWolf Web Browser"
echo "========================================================================"

sudo apt update
sudo apt -y install extrepo
sudo extrepo enable librewolf
sudo apt update
sudo apt -y install librewolf

echo "========================================================================"
echo "Add LibreWolf as a DebianAlternatives"
echo "x-www-browser option"
echo "========================================================================"

sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/librewolf 201

echo "========================================================================"
echo "Option to set LibreWolf as the default DebianAlternatives"
echo "(x-www-browser) web browser"
echo "------------------------------------------------------------------------"

while true; do
    read -rp "Do you want to set LibreWolf as the default DebianAlternatives (x-www-browser) browser? (y/n) " yn
    case $yn in
        [Yy]* ) sudo update-alternatives --set x-www-browser /usr/bin/librewolf;
                echo "You chose to set LibreWolf as the default browser";
                break;;
        [Nn]* ) echo "You chose not to set LibreWolf as the default browser";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "========================================================================"
echo "All done, LibreWolf Web Browser is now installed"
echo "========================================================================"
