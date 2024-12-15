#!/bin/bash

# ============================================================================
# Debian (post-install) Gnome Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-gnome.sh
# ----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the Gnome desktop
# environment and a base set of apps for a ready-to-use desktop session.
# ----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-gnome.sh
# ============================================================================

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
echo "Install Gnome and other packages"
echo "#########################################################"

sudo apt -y install gnome-core gnome-tweaks gnome-shell-extension-manager adwaita-qt qgnomeplatform-qt5 papirus-icon-theme fonts-noto-color-emoji plymouth-themes file-roller rhythmbox synaptic mintstick firefox-esr gcolor3 darktable gimp inkscape filezilla libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3 soundconverter timeshift dconf-editor nfs-common cifs-utils libimage-exiftool-perl micro fzf htop neofetch cava cmatrix apt-transport-https curl xclip input-remapper-gtk

echo "#########################################################"
echo "Replace default Files app with Nemo"
echo "#########################################################"

sudo apt -y install nemo nemo-fileroller
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search
mkdir -p ~/.local/share/dbus-1/services
ln -s /usr/share/dbus-1/services/nemo.FileManager1.service ~/.local/share/dbus-1/services/

echo "#########################################################"
echo "Install Signal App"
echo "#########################################################"

curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt -y install signal-desktop

echo "#########################################################"
echo "Clone custom configuration files"
echo "#########################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "#########################################################"
echo "Copy custom configuration files"
echo "#########################################################"

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/opt-dots/gnome/.config $HOME
cp -R $HOME/opt-dots/gnome/.local $HOME
cp -R $HOME/opt-dots/gnome/.bashrc $HOME
cp -R $HOME/opt-dots/gnome/.profile $HOME
cp -R $HOME/opt-dots/gnome/.Xresources $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo mkdir -p /usr/share/gtksourceview-5
sudo cp -R /usr/share/gtksourceview-4/* /usr/share/gtksourceview-5
sudo cp -R $HOME/opt-dots/gnome/etc/gdm3 /etc
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo update-initramfs -u
sudo update-grub

echo "#########################################################"
echo "Add user .bash_profile and .xsessionrc files"
echo "#########################################################"

echo "if [ -f ~/.profile ]; then
    . ~/.profile
fi" | tee $HOME/.bash_profile $HOME/.xsessionrc > /dev/null

echo "#########################################################"
echo "Update root .bashrc file"
echo "#########################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc > /dev/null

echo "#########################################################"
echo "Add bookmarks and clean up directories"
echo "#########################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sudo rm /usr/share/applications/imv-folder.desktop
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
