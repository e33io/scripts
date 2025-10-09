#!/bin/bash

# =============================================================================
# Install Custom Mint Themes
# URL: https://github.com/e33io/scripts/blob/main/install-custom-mint-themes.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian or Arch Linux!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

if ! { [ -f "/etc/debian_version" ] || [ -f "/etc/pacman.conf" ]; }; then
    echo "========================================================================"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Debian or Arch Linux and it will"
    echo "exit now without running."
    echo "========================================================================"
    exit 1
fi

echo "========================================================================"
echo "Remove obsolete themes"
echo "========================================================================"

sudo rm -rf /usr/share/Kvantum/Mint-L-*
sudo rm -rf /usr/share/Kvantum/Mint-Y-*
sudo rm -rf /usr/share/themes/Mint-*Mod-*

echo "========================================================================"
echo "Install theming dependencies"
echo "========================================================================"

if [ -f "/etc/debian_version" ]; then
    sudo apt update
    sudo apt -y install gnome-themes-extra gtk2-engines gtk2-engines-murrine gtk2-engines-pixbuf libglib2.0-bin \
    libgtk-3-common libgtk-4-common libgtk2.0-common adwaita-qt* qt-style-kvantum git
fi

if [ -f "/etc/pacman.conf" ]; then
    if ! command -v yay > /dev/null 2>&1; then
        echo "========================================================================"
        echo "Setup Yay for AUR"
        echo "========================================================================"

        git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
        cd $HOME/yay-bin
        makepkg -si --noconfirm
        cd
        rm -rf $HOME/yay-bin
    fi
    sudo pacman -Syu --noconfirm --needed gnome-themes-extra gtk-engine-murrine kvantum kvantum-qt5 less git
    yay -S --noconfirm --needed --sudoloop adwaita-qt5 adwaita-qt6
fi

if [ ! -f "/bin/lxqt-session" ]; then
    if [ -f "/etc/debian_version" ]; then
        sudo apt -y install qt*ct
    fi
    if [ -f "/etc/pacman.conf" ]; then
        sudo pacman -S --noconfirm --needed qt5ct qt6ct
    fi
fi

echo "========================================================================"
echo "Clone custom theming repo"
echo "========================================================================"

git clone https://github.com/e33io/theming $HOME/theming-temp

echo "========================================================================"
echo "Copy custom Mint themes"
echo "========================================================================"

sudo cp -R $HOME/theming-temp/gtk/Mint* /usr/share/themes
sudo mkdir -p /usr/share/Kvantum
sudo cp -R $HOME/theming-temp/Kvantum/Mint* /usr/share/Kvantum

echo "========================================================================"
echo "Link config files to root user directories for styling"
echo "su/root applications"
echo "========================================================================"

sudo mkdir -p /root/.config

if [ -f "/usr/bin/lxappearance" ]; then
    if [ ! -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
        mkdir -p $HOME/.config/gtk-3.0
        touch $HOME/.config/gtk-3.0/settings.ini
    fi
    if [ ! -f "$HOME/.gtkrc-2.0" ]; then
        touch $HOME/.gtkrc-2.0
    fi
    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf $HOME/.config/gtk-3.0/* /root/.config/gtk-3.0
    sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
fi

if [ -f "/usr/bin/kvantummanager" ]; then
    if [ ! -f "$HOME/.config/Kvantum/kvantum.kvconfig" ]; then
        mkdir -p $HOME/.config/Kvantum
        touch $HOME/.config/Kvantum/kvantum.kvconfig
    fi
    sudo mkdir -p /root/.config/Kvantum
    sudo ln -sf $HOME/.config/Kvantum/* /root/.config/Kvantum
fi

if [ -f "/usr/bin/qt5ct" ]; then
    if [ ! -f "$HOME/.config/qt5ct/qt5ct.conf" ]; then
        mkdir -p $HOME/.config/qt5ct
        touch $HOME/.config/qt5ct/qt5ct.conf
    fi
    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf $HOME/.config/qt5ct/* /root/.config/qt5ct
fi

if [ -f "/usr/bin/qt6ct" ]; then
    if [ ! -f "$HOME/.config/qt6ct/qt6ct.conf" ]; then
        mkdir -p $HOME/.config/qt6ct
        touch $HOME/.config/qt6ct/qt6ct.conf
    fi
    sudo mkdir -p /root/.config/qt6ct
    sudo ln -sf $HOME/.config/qt6ct/* /root/.config/qt6ct
fi

echo "========================================================================"
echo "Clean up directories"
echo "========================================================================"

echo "Custom Mint themes installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a $HOME/.install-info > /dev/null
rm -rf $HOME/theming-temp

echo "========================================================================"
echo "All done, themes and icons are now installed"
echo "========================================================================"
