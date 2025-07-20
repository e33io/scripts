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

if [ -f "/bin/gnome-shell" ]; then
    echo "################################################################"
    echo "Install Yaru Gnome shell theme and Yaru sound theme"
    echo "################################################################"

    sudo apt -y install yaru-theme-gnome-shell yaru-theme-sound
else
    echo "################################################################"
    echo "Install Qt and Kvantum styling packages for desktop"
    echo "environments and window managers other than Gnome"
    echo "################################################################"

    sudo apt -y install adwaita-qt* qt*-style-kvantum git

    echo "################################################################"
    echo "Clone and copy Kvantum KvYaru-Colors Qt themes"
    echo "################################################################"

    git clone https://github.com/GabePoel/KvYaru-Colors.git $HOME/KvYaru-Colors
    sudo cp -R $HOME/KvYaru-Colors/src/* /usr/share/Kvantum
    rm -rf $HOME/KvYaru-Colors

    echo "################################################################"
    echo "Update Kvantum KvYaru theme colors to correctly match"
    echo "Yaru GTK theme colors, and update window tabs from"
    echo "center-alignment to the standard left-alignment"
    echo "################################################################"

    sudo sed -i 's/#208fe9/#0073e5/g' /usr/share/Kvantum/KvYaru-Blue/KvYaru-Blue*
    sudo sed -i 's/#3eb34f/#03875b/g' /usr/share/Kvantum/KvYaru-Green/KvYaru-Green*
    sudo sed -i 's/#924d8b/#7764d8/g' /usr/share/Kvantum/KvYaru-Purple/KvYaru-Purple*
    sudo sed -i 's/#16a085/#308280/g' /usr/share/Kvantum/KvYaru-Teal/KvYaru-Teal*
    sudo sed -i 's/left_tabs=false/left_tabs=true/g' /usr/share/Kvantum/KvYaru*/KvYaru*
fi

if ! { [ -f "/bin/gnome-shell" ] || [ -f "/bin/lxqt-session" ]; }; then
    echo "################################################################"
    echo "Install Qt packages for desktop environments and"
    echo "window managers other than Gnome or LXQt"
    echo "################################################################"

    sudo apt -y install qt*ct
fi

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
