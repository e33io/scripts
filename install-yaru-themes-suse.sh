#!/bin/bash

# ================================================================================
# Install Yaru Themes and Icons
# URL: https://github.com/e33io/scripts/blob/main/install-yaru-themes-suse.sh
# --------------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with openSUSE Linux!
# ================================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

if [ ! -f "/etc/zypp/zypper.conf" ]; then
    echo "#########################################################"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with openSUSE Linux, and it will exit now"
    echo "without running or making any changes."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Install Yaru themes, icons and dependencies"
echo "#########################################################"

sudo zypper refresh
sudo zypper install metatheme-yaru-common metatheme-yaru-mate-common gnome-themes-extras

echo "#########################################################"
echo "Remove prespecified GTK2 icon sizes to fix scaling issues"
echo "#########################################################"

sudo sed -i 's/gtk-icon-sizes.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-menu.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-button.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-small-toolbar.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dnd.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dialog.*/#/' /usr/share/themes/Yaru*/gtk-2.0/gtkrc

if [ -f "/bin/gnome-shell" ]; then
    echo "#########################################################"
    echo "Install Yaru Gnome shell theme"
    echo "#########################################################"

    sudo zypper install gnome-shell-theme-yaru

    echo "#########################################################"
    echo "Remove unneeded font-weight override to fix font-weight"
    echo "issues in Gnome shell panel (top bar)"
    echo "#########################################################"

    sudo sed -i 's/font-weight: normal !important;/\/\* font-weight: normal !important; \*\//' /usr/share/gnome-shell/theme/Yaru*/gnome-shell.css
else
    echo "#########################################################"
    echo "Install Qt and Kvantum styling packages for desktop"
    echo "environments and window managers other than Gnome"
    echo "#########################################################"

    sudo zypper install adwaita-qt5 kvantum-manager kvantum-qt5 git

    echo "#########################################################"
    echo "Clone and copy Kvantum KvYaru-Colors Qt themes"
    echo "#########################################################"

    git clone https://github.com/GabePoel/KvYaru-Colors.git $HOME/KvYaru-Colors
    sudo cp -R $HOME/KvYaru-Colors/src/* /usr/share/Kvantum
    sudo rm -Rf $HOME/KvYaru-Colors

    echo "#########################################################"
    echo "Update Kvantum KvYaru theme colors to correctly match"
    echo "Yaru GTK theme colors, and update window tabs from"
    echo "center-alignment to the standard left-alignment"
    echo "#########################################################"

    sudo sed -i 's/#208fe9/#0073e5/g' /usr/share/Kvantum/KvYaru-Blue/KvYaru-Blue*
    sudo sed -i 's/#3eb34f/#03875b/g' /usr/share/Kvantum/KvYaru-Green/KvYaru-Green*
    sudo sed -i 's/#78ab50/#87a556/g' /usr/share/Kvantum/KvYaru-MATE/KvYaru-MATE*
    sudo sed -i 's/#924d8b/#7764d8/g' /usr/share/Kvantum/KvYaru-Purple/KvYaru-Purple*
    sudo sed -i 's/#16a085/#308280/g' /usr/share/Kvantum/KvYaru-Teal/KvYaru-Teal*
    sudo sed -i 's/left_tabs=false/left_tabs=true/g' /usr/share/Kvantum/KvYaru*/KvYaru*
fi

if ! { [ -f "/bin/gnome-shell" ] || [ -f "/bin/lxqt-session" ]; }; then
    echo "#########################################################"
    echo "Install Qt packages for desktop environments and"
    echo "window managers other than Gnome or LXQt"
    echo "#########################################################"

    sudo zypper install qt5ct
fi

if [ -f "/usr/bin/lxappearance" ]; then
    echo "#########################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using lxappearance app"
    echo "#########################################################"

    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
    sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
fi

if [ -f "/usr/bin/kvantummanager" ]; then
    echo "#########################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using kvantummanager app"
    echo "#########################################################"

    sudo mkdir -p /root/.config/Kvantum
    sudo ln -sf $HOME/.config/Kvantum/kvantum.kvconfig /root/.config/Kvantum/kvantum.kvconfig
fi

if [ -f "/usr/bin/qt5ct" ]; then
    echo "#########################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using qt5ct app"
    echo "#########################################################"

    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
fi

echo "#########################################################"
echo "All done, themes and icons are now installed"
echo "#########################################################"
