#!/bin/bash

# =============================================================================
# Install Brave Browser from Brave's apt-release package repos
# URL: https://github.com/e33io/scripts/blob/main/install-brave-deb.sh
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

sudo apt -y install apt-transport-https curl

echo "========================================================================"
echo "Install Brave Browser"
echo "========================================================================"

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
https://brave-browser-apt-release.s3.brave.com/ stable main" \
| sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt -y install brave-browser

echo "========================================================================"
echo "Option to set Brave as the default DebianAlternatives"
echo "(x-www-browser) web browser"
echo "------------------------------------------------------------------------"

while true; do
    read -rp "Do you want to set Brave as the default DebianAlternatives (x-www-browser) browser? (y/n) " yn
    case $yn in
        [Yy]* ) sudo update-alternatives --set x-www-browser /usr/bin/brave-browser-stable;
                echo "You chose to set Brave as the default browser";
                break;;
        [Nn]* ) echo "You chose not to set Brave as the default browser";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "========================================================================"
echo "All done, Brave Browser is now installed"
echo "========================================================================"
