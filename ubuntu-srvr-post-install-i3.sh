#!/bin/bash

# ==============================================================================
# Ubuntu 24.04 Server (post-install) i3 Installation
# URL: https://github.com/e33io/scripts/blob/main/ubuntu-srvr-post-install-i3.sh
# Installation steps and other configuration options: https://e33.io/1793
# ------------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with an Ubuntu 24.04 Server installation to install the i3 window
# manager and a base set of apps for a ready-to-use desktop session.
# ------------------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors
# (192 dpi settings for 2x scaling) and desktop-type computers,
# but there are options at the end of the script that let you change
# to non-HiDPI monitors (96 dpi settings for 1x scaling),
# and/or change to laptop-type (battery powered) computer settings.
# ------------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh ubuntu-srvr-post-install-i3.sh
# ==============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Update and upgrade system"
echo "################################################################"

sudo apt update
sudo apt -y upgrade
sudo apt -y dist-upgrade

echo "################################################################"
echo "Remove unneeded packages"
echo "################################################################"

sudo apt -y purge apport* byobu cloud-* finalrd *fwupd* lxd-* multipath-tools needrestart networkd-dispatcher open-iscsi open-vm-tools pollinate postfix rsyslog thermald tpm-* ufw unattended-upgrades
sudo apt -y autoremove
sudo apt -y autoclean

echo "################################################################"
echo "Disable unneeded services and remove/de-prioritize snapd"
echo "################################################################"

sudo systemctl disable systemd-networkd-wait-online.service
sudo systemctl disable systemd-networkd.service
sudo systemctl disable systemd-networkd.socket
sudo systemctl disable ubuntu-advantage.service
sudo systemctl stop snapd.service
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo apt -y purge snapd
sudo apt -y autoremove
sudo apt -y autoclean
echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" | sudo tee /etc/apt/preferences.d/nosnap.pref > /dev/null

echo "################################################################"
echo "Update deb-post-install-i3.sh script"
echo "################################################################"

sed -i 's/sudo rm -R \$HOME\/scripts/#/' $HOME/scripts/deb-post-install-i3.sh

echo "################################################################"
echo "Run deb-post-install-i3.sh script to"
echo "install i3 and other applications"
echo "################################################################"

sh deb-post-install-i3.sh

echo "################################################################"
echo "Run install-yaru-themes.sh script to"
echo "install Yaru themes and icons"
echo "################################################################"

sh install-yaru-themes.sh

echo "################################################################"
echo "Disable ESM hook to turn off ESM upgrade messages"
echo "################################################################"

sudo mv /etc/apt/apt.conf.d/20apt-esm-hook.conf /etc/apt/apt.conf.d/20apt-esm-hook.conf.bak

echo "################################################################"
echo "Update NetworkManager files and apply changes"
echo "################################################################"

echo "# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager" | sudo tee /etc/netplan/01-network-manager-all.yaml > /dev/null
sudo rm -R /etc/network/interfaces
sudo netplan generate
sudo netplan apply

echo "################################################################"
echo "Update the swap swappiness value"
echo "################################################################"

echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf > /dev/null

echo "################################################################"
echo "Add info.desktop file"
echo "################################################################"

echo "[Desktop Entry]
Name=TeXInfo
Exec=info
Icon=dialog-information
Terminal=true
Type=Application
Categories=Utility;ConsoleOnly;
NoDisplay=true" > $HOME/.local/share/applications/info.desktop

echo "################################################################"
echo "Update cursor, lightdm and plymouth settings"
echo "################################################################"

sed -i 's/gtk-cursor-theme-name="Adwaita"/gtk-cursor-theme-name="Yaru"/' $HOME/.gtkrc-2.0
sed -i 's/gtk-cursor-theme-name=Adwaita/gtk-cursor-theme-name=Yaru/' $HOME/.config/gtk-3.0/settings.ini
sed -i 's/Inherits=Adwaita/Inherits=Yaru/' $HOME/.icons/default/index.theme
sed -i 's/Xcursor\.theme: Adwaita/Xcursor\.theme: Yaru/' $HOME/.Xresources
sudo sed -i 's/cursor-theme-name=Adwaita/cursor-theme-name=Yaru/' /etc/lightdm/slick-greeter.conf
sudo sed -i 's/theme-name=Adwaita-dark/theme-name=Yaru-dark/' /etc/lightdm/slick-greeter.conf
sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
sudo update-initramfs -u

echo "################################################################"
echo "Clean up /usr/share/applications directory"
echo "################################################################"

sudo rm -R /usr/share/applications/imv-folder.desktop

echo "################################################################"
echo "Clean up user directory"
echo "################################################################"

sudo rm -R $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
