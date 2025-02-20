#!/bin/bash

# ===========================================================================
# Install Firefox Web Browser from Mozilla's .deb package repos
# URL: https://github.com/e33io/scripts/blob/main/install-firefox-deb.sh
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# ===========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Install dependencies"
echo "#########################################################"

sudo apt -y install apt-transport-https curl

echo "#########################################################"
echo "Install Firefox Web Browser"
echo "#########################################################"

curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/packages.mozilla.org.gpg
echo "deb [signed-by=/usr/share/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list
echo "Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla > /dev/null
sudo apt update
sudo apt -y install firefox

echo "#########################################################"
echo "Add Firefox as a DebianAlternatives x-www-browser option"
echo "#########################################################"

sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/lib/firefox/firefox 200

echo "#########################################################"
echo "Option to set Firefox as the default DebianAlternatives"
echo "(x-www-browser) web browser"
echo "---------------------------------------------------------"

while true; do
    read -p "Do you want to set Firefox as the default DebianAlternatives (x-www-browser) browser? (y/n) " yn
    case $yn in
        [Yy]* ) sudo update-alternatives --set x-www-browser /usr/lib/firefox/firefox;
                echo "You chose to set Firefox as the default browser";
                break;;
        [Nn]* ) echo "You chose not to set Firefox as the default browser";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "#########################################################"
echo "All done, Firefox Web Browser is now installed"
echo "#########################################################"
