#!/bin/bash

# ======================================================================
# Install Yaru Themes and Icons
# URL: https://github.com/e33io/scripts/blob/main/install-yaru-themes.sh
# ----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian/Ubuntu Linux!
# ======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

if [ ! -f "/etc/debian_version" ]; then
    echo "################################################################"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Debian or Ubuntu Linux, and it will"
    echo "exit now without running or making any changes."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Install Yaru themes, icons and dependencies"
echo "################################################################"

sudo apt update
sudo apt -y install yaru-theme-gtk yaru-theme-icon gnome-themes-extra gtk2-engines gtk2-engines-murrine \
gtk2-engines-pixbuf libglib2.0-bin libgtk-3-common libgtk-4-common libgtk2.0-common

echo "################################################################"
echo "Remove prespecified GTK2 icon sizes to fix scaling issues"
echo "################################################################"

sudo sed -i 's/gtk-icon-sizes.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-menu.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-button.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-small-toolbar.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dnd.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dialog.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc

echo "################################################################"
echo "Install Qt and Kvantum styling packages"
echo "################################################################"

sudo apt -y install adwaita-qt* qt-style-kvantum git

if [ ! -f "/bin/lxqt-session" ]; then
    sudo apt -y install qt*ct
fi

echo "################################################################"
echo "Clone custom theming repo"
echo "################################################################"

git clone https://github.com/e33io/theming $HOME/theming-temp

echo "################################################################"
echo "Copy custom Yaru Kvantum themes"
echo "################################################################"

sudo mkdir -p /usr/share/Kvantum
sudo cp -R $HOME/theming-temp/Kvantum/Yaru* /usr/share/Kvantum
rm -rf $HOME/theming-temp

echo "################################################################"
echo "Link config files to root user directories for styling"
echo "su/root applications"
echo "################################################################"

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

echo "################################################################"
echo "All done, themes and icons are now installed"
echo "################################################################"
