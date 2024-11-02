#!/bin/bash

# ================================================================================
# Install Linux Mint Themes and Icons
# URL: https://github.com/e33io/scripts/blob/main/install-mint-themes-suse.sh
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
echo "Install Mint themes and dependencies"
echo "#########################################################"

sudo zypper refresh
sudo zypper install metatheme-mint-common gnome-themes-extras git

echo "#########################################################"
echo "Remove prespecified GTK2 icon sizes to fix scaling issues"
echo "#########################################################"

sudo sed -i 's/gtk-icon-sizes.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-menu.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-button.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-small-toolbar.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dnd.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dialog.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc

if [ -f "/usr/bin/lxappearance" ]; then
    echo "#########################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using lxappearance app"
    echo "#########################################################"

    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
    sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
fi

echo "#########################################################"
echo "Clone custom theming repo"
echo "#########################################################"

git clone https://github.com/e33io/theming $HOME/theming-temp

echo "#########################################################"
echo "Copy custom Mint Dark Mod themes"
echo "#########################################################"

sudo cp -R $HOME/theming-temp/gtk/* /usr/share/themes

echo "#########################################################"
echo "Install Qt and Kvantum styling packages"
echo "#########################################################"

sudo zypper install adwaita-qt5 kvantum-manager kvantum-qt5

if [ ! -f "/bin/lxqt-session" ]; then
    sudo zypper install qt5ct
fi

echo "#########################################################"
echo "Copy custom Kvantum Qt themes"
echo "#########################################################"

sudo cp -R $HOME/theming-temp/Kvantum /usr/share

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
    echo "su/root applications if using qt5ct and/or qt6ct app"
    echo "#########################################################"

    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
fi

echo "#########################################################"
echo "Clean up user directory"
echo "#########################################################"

sudo rm -Rf $HOME/theming-temp

echo "#########################################################"
echo "All done, themes and icons are now installed"
echo "#########################################################"
