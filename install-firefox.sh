#!/bin/bash

# =======================================================================
# Install Firefox Web Browser from Mozilla's latest builds
# URL: https://github.com/e33io/scripts/blob/main/install-firefox.sh
# -----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# This method is for the current user only, and will auto-update
# -----------------------------------------------------------------------
# NOTE: If your active icon theme doesn't have a Firefox icon,
#       update the `Icon` path in the firefox.desktop file
#       to a Firefox icon on your system
# =======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

# make directories
mkdir -p $HOME/.local/applications
mkdir -p $HOME/.local/share/applications

# download and extract tar
wget -O firefoxsetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
tar -xf firefoxsetup.tar.bz2 --directory $HOME/.local/applications

# write firefox.desktop file
echo "[Desktop Entry] 
Name=Firefox
GenericName=Web Browser
Comment=Browse the Web
Exec=/home/$(whoami)/.local/applications/firefox/firefox %u
Icon=firefox
Terminal=false
Type=Application
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/x-xpinstall;application/xhtml+xml;application/xml;text/html;text/xml;x-scheme-handler/chrome;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/mailto;
Categories=Network;WebBrowser;
Keywords=web;browser;internet;
StartupNotify=true" > $HOME/.local/share/applications/firefox.desktop

# make symbolic link to /usr/local/bin
sudo ln -s $HOME/.local/applications/firefox/firefox /usr/local/bin/firefox

# if using Debian, add Firefox as a DebianAlternatives x-www-browser option
# and have the option to set Firefox as the default DebianAlternatives
# (x-www-browser) web browser
if [ -f "/etc/debian_version" ]; then
    sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/local/bin/firefox 200
    while true; do
        read -p "Do you want to set Firefox as the default DebianAlternatives (x-www-browser) browser? (y/n) " yn
        case $yn in
            [Yy]* ) sudo update-alternatives --set x-www-browser /usr/local/bin/firefox;
                    echo "You chose to set Firefox as the default browser";
                    break;;
            [Nn]* ) echo "You chose not to set Firefox as the default browser";
                    break;;
            * ) echo "Please answer y (for yes) or n (for no)";;
        esac
    done
fi

echo "#########################################################"
echo "All done, Firefox Web Browser is now installed"
echo "#########################################################"
