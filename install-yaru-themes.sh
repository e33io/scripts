#!/bin/bash

# =============================================================================
# Install Yaru Themes and Icons
# URL: https://github.com/e33io/scripts/blob/main/install-yaru-themes.sh
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

if ! { [ -f /etc/debian_version ] || [ -f /etc/pacman.conf ]; } then
    echo "========================================================================"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Debian or Arch Linux and it will"
    echo "exit now without running."
    echo "========================================================================"
    exit 1
fi

if [ -f /etc/debian_version ]; then
    echo "========================================================================"
    echo "Install Yaru themes, icons and dependencies"
    echo "========================================================================"

    sudo apt update
    sudo apt -y install yaru-theme-gtk yaru-theme-icon gnome-themes-extra gtk2-engines gtk2-engines-murrine \
    gtk2-engines-pixbuf libglib2.0-bin libgtk-3-common libgtk-4-common libgtk2.0-common

    echo "========================================================================"
    echo "Install Qt and Kvantum styling packages"
    echo "========================================================================"

    sudo apt -y install adwaita-qt* qt-style-kvantum git

    if ! command -v lxqt-session > /dev/null 2>&1; then
        sudo apt -y install qt*ct
    fi
fi

if [ -f /etc/pacman.conf ]; then
    if ! command -v yay > /dev/null 2>&1; then
        echo "========================================================================"
        echo "Setup Yay for AUR"
        echo "========================================================================"

        git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
        cd ~/yay-bin
        makepkg -si --noconfirm
        cd
        rm -rf ~/yay-bin
    fi

    echo "========================================================================"
    echo "Install Yaru themes and dependencies"
    echo "========================================================================"

    sudo pacman -Syu --noconfirm --needed gnome-themes-extra less git
    yay -S --noconfirm --needed --sudoloop yaru-gtk-theme yaru-icon-theme

    echo "========================================================================"
    echo "Install Qt and Kvantum styling packages"
    echo "========================================================================"

    sudo pacman -Syu --noconfirm --needed kvantum kvantum-qt5
    yay -S --noconfirm --needed --sudoloop adwaita-qt5 adwaita-qt6

    if ! command -v lxqt-session > /dev/null 2>&1; then
        sudo pacman -S --noconfirm --needed qt5ct qt6ct
    fi
fi

echo "========================================================================"
echo "Remove prespecified GTK2 icon sizes to fix scaling issues"
echo "========================================================================"

sudo sed -i -e '/gtk-icon-sizes/d' -e '/gtk-menu/d' -e '/gtk-button/d' -e '/gtk-small-toolbar/d' \
-e '/gtk-dnd/d' -e '/gtk-dialog/d' /usr/share/themes/Yaru*/gtk-2.0/gtkrc

echo "========================================================================"
echo "Clone custom theming repo"
echo "========================================================================"

git clone https://github.com/e33io/theming ~/theming-temp

echo "========================================================================"
echo "Copy custom Yaru themes"
echo "========================================================================"

sudo mkdir -p /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru* /usr/share/Kvantum
rm -rf ~/theming-temp

echo "========================================================================"
echo "Link config files to root user directories for styling"
echo "su/root applications"
echo "========================================================================"

sudo mkdir -p /root/.config

if command -v lxappearance > /dev/null 2>&1; then
    if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
        mkdir -p ~/.config/gtk-3.0
        touch ~/.config/gtk-3.0/settings.ini
    fi
    if [ ! -f ~/.gtkrc-2.0 ]; then
        touch ~/.gtkrc-2.0
    fi
    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf ~/.config/gtk-3.0/* /root/.config/gtk-3.0
    sudo ln -sf ~/.gtkrc-2.0 /root/.gtkrc-2.0
fi

if command -v kvantummanager > /dev/null 2>&1; then
    if [ ! -f ~/.config/Kvantum/kvantum.kvconfig ]; then
        mkdir -p ~/.config/Kvantum
        touch ~/.config/Kvantum/kvantum.kvconfig
    fi
    sudo mkdir -p /root/.config/Kvantum
    sudo ln -sf ~/.config/Kvantum/* /root/.config/Kvantum
fi

if command -v qt5ct > /dev/null 2>&1; then
    if [ ! -f ~/.config/qt5ct/qt5ct.conf ]; then
        mkdir -p ~/.config/qt5ct
        touch ~/.config/qt5ct/qt5ct.conf
    fi
    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf ~/.config/qt5ct/* /root/.config/qt5ct
fi

if command -v qt6ct > /dev/null 2>&1; then
    if [ ! -f ~/.config/qt6ct/qt6ct.conf ]; then
        mkdir -p ~/.config/qt6ct
        touch ~/.config/qt6ct/qt6ct.conf
    fi
    sudo mkdir -p /root/.config/qt6ct
    sudo ln -sf ~/.config/qt6ct/* /root/.config/qt6ct
fi

echo "========================================================================"
echo "All done, themes and icons are now installed"
echo "========================================================================"
