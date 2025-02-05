#!/bin/bash

# ===================================================================
# Install Firefox Web Browser from Mozilla's latest builds
# URL: https://github.com/e33io/scripts/blob/main/install-firefox.sh
# -------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# This method is for the current user only, and will auto-update
# -------------------------------------------------------------------
# NOTE: If your active icon theme doesn't have a Firefox icon,
#       update the `Icon` path in the firefox.desktop file
#       to a Firefox icon on your system
# ===================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

# make directories
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share/applications

# download and extract tar
wget -O firefoxsetup.tar.xz "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
tar -xf firefoxsetup.tar.xz --directory $HOME/.local

# write firefox.desktop file
echo "[Desktop Entry] 
Name=Firefox
GenericName=Web Browser
Comment=Browse the Web
Exec=/home/$(whoami)/.local/firefox/firefox %u
Icon=firefox
Terminal=false
Type=Application
MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/x-xpinstall;application/xhtml+xml;application/xml;text/html;text/xml;x-scheme-handler/chrome;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/mailto;
Categories=Network;WebBrowser;
Keywords=web;browser;internet;
StartupNotify=true" > $HOME/.local/share/applications/firefox.desktop

# make symbolic link to $HOME/.local/bin
ln -s $HOME/.local/firefox/firefox $HOME/.local/bin/firefox

echo "########################################################"
echo "Clean up directory"
echo "########################################################"

rm -R $PWD/firefoxsetup.tar.xz

echo "#########################################################"
echo "All done, Firefox Web Browser is now installed"
echo "#########################################################"
