#!/bin/bash

# ==============================================================================
# Debian/Ubuntu Replace Default Gnome Files App with Nemo File Manager
# URL: https://git.sr.ht/~e33io/scripts/tree/main/item/gnome-install-nemo-deb.sh
# ------------------------------------------------------------------------------
# NOTE: Only use with the Gnome desktop environment on Debian/Ubuntu!
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
echo "Update and upgrade system"
echo "#########################################################"

sudo apt update
sudo apt -y upgrade

echo "#########################################################"
echo "Replace default Files app with Nemo"
echo "#########################################################"

sudo apt -y install nemo nemo-fileroller xclip
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
mkdir -p ~/.local/share/dbus-1/services
ln -s /usr/share/dbus-1/services/nemo.FileManager1.service ~/.local/share/dbus-1/services/

echo "#########################################################"
echo "Add copy_full_path.nemo_action file"
echo "#########################################################"

mkdir -p $HOME/.local/share/nemo/actions
echo '[Nemo Action]
Name=Copy Full Path
Comment=Copy full path of selected file or directory
Exec=bash -c "echo -n %F | xclip -selection clipboard"
Icon-Name=edit-copy
Selection=s
Extensions=any

[Desktop Entry]
Name[en_US]=copy_full_path.nemo_action' > $HOME/.local/share/nemo/actions/copy_full_path.nemo_action

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
