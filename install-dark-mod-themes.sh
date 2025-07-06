#!/bin/bash

# ==========================================================================
# Install Mint Dark Mod Themes
# URL: https://github.com/e33io/scripts/blob/main/install-dark-mod-themes.sh
# --------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian or Arch Linux!
# ==========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

if ! { [ -f "/etc/debian_version" ] || [ -f "/etc/pacman.conf" ]; }; then
    echo "################################################################"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Debian or Arch Linux and it will"
    echo "exit now without running."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Install theming dependencies"
echo "################################################################"

if [ -f "/etc/debian_version" ]; then
    sudo apt update
    sudo apt -y install gnome-themes-extra gtk2-engines gtk2-engines-murrine gtk2-engines-pixbuf libglib2.0-bin \
    libgtk-3-common libgtk-4-common libgtk2.0-common adwaita-qt* qt5-style-kvantum git
fi

if [ -f "/etc/pacman.conf" ]; then
    if ! command -v yay &>/dev/null; then
        echo "################################################################"
        echo "Setup Yay for AUR"
        echo "################################################################"
        
        git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
        cd $HOME/yay-bin
        makepkg -si --noconfirm
        cd
        rm -rf $HOME/yay-bin
    fi
    sudo pacman -Syu --noconfirm --needed gnome-themes-extra gtk-engine-murrine kvantum kvantum-qt5 less git
    yay -S --noconfirm --needed --sudoloop adwaita-qt5-git adwaita-qt6-git
fi

if [ ! -f "/bin/lxqt-session" ]; then
    if [ -f "/etc/debian_version" ]; then
        sudo apt -y install qt*ct
    fi
    if [ -f "/etc/pacman.conf" ]; then
        sudo pacman -S --noconfirm --needed qt5ct qt6ct
    fi
fi

echo "################################################################"
echo "Clone custom theming repo"
echo "################################################################"

git clone https://github.com/e33io/theming $HOME/theming-temp

echo "################################################################"
echo "Copy custom Mint Dark Mod themes"
echo "################################################################"

sudo cp -R $HOME/theming-temp/gtk/* /usr/share/themes
sudo mkdir -p /usr/share/Kvantum
sudo cp -R $HOME/theming-temp/Kvantum/Mint-*-Dark-Mod-* /usr/share/Kvantum

echo "################################################################"
echo "Link config files to root user directories for styling"
echo "su/root applications"
echo "################################################################"

sudo mkdir -p /root/.config

if [ -f "/usr/bin/lxappearance" ]; then
    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf $HOME/.config/gtk-3.0/* /root/.config/gtk-3.0
    sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
fi

if [ -f "/usr/bin/kvantummanager" ]; then
    mkdir -p $HOME/.config/Kvantum
    touch $HOME/.config/Kvantum/kvantum.kvconfig
    sudo mkdir -p /root/.config/Kvantum
    sudo ln -sf $HOME/.config/Kvantum/* /root/.config/Kvantum
fi

if [ -f "/usr/bin/qt5ct" ]; then
    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf $HOME/.config/qt5ct/* /root/.config/qt5ct
fi

if [ -f "/usr/bin/qt6ct" ]; then
    sudo mkdir -p /root/.config/qt6ct
    sudo ln -sf $HOME/.config/qt6ct/* /root/.config/qt6ct
fi

echo "################################################################"
echo "Clean up user directory"
echo "################################################################"

rm -rf $HOME/theming-temp

echo "################################################################"
echo "All done, themes and icons are now installed"
echo "################################################################"
