#!/bin/bash

# ===========================================================================
# Install Thunderbird Email Client from Mozilla's latest builds
# URL: https://git.sr.ht/~e33io/scripts/tree/main/item/install-thunderbird.sh
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# This method is for the current user only, and will auto-update
# ---------------------------------------------------------------------------
# NOTE: If your active icon theme doesn't have a Thunderbird icon,
#       update the `Icon` path in the thunderbird.desktop file
#       to a Thunderbird icon on your system
# ===========================================================================

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
wget -O thunderbirdsetup.tar.bz2 "https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=en-US"
tar -xf thunderbirdsetup.tar.bz2 --directory $HOME/.local/applications

# write thunderbird.desktop file
echo "[Desktop Entry] 
Name=Thunderbird
GenericName=Email Client
Comment=Send and Receive Email
Exec=/home/$(whoami)/.local/applications/thunderbird/thunderbird %u
Icon=thunderbird
Terminal=false
X-MultipleArgs=false
Type=Application
MimeType=message/rfc822;x-scheme-handler/mailto;text/calendar;text/x-vcard;
Categories=Network;Email;
Keywords=email;contact;addressbook;news;
StartupWMClass=thunderbird-default
StartupNotify=true" > $HOME/.local/share/applications/thunderbird.desktop

# make symbolic link to /usr/local/bin
sudo ln -s $HOME/.local/applications/thunderbird/thunderbird /usr/local/bin/thunderbird

echo "#########################################################"
echo "All done, Thunderbird Email Client is now installed"
echo "#########################################################"
