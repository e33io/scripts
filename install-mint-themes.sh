#!/bin/bash

# ======================================================================
# Install Linux Mint Themes and Icons
# URL: https://github.com/e33io/scripts/blob/main/install-mint-themes.sh
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
echo "Install theming dependencies"
echo "################################################################"

sudo apt update
sudo apt -y install gnome-themes-extra gtk2-engines gtk2-engines-murrine gtk2-engines-pixbuf libglib2.0-bin libgtk-3-common libgtk-4-common libgtk2.0-common curl git

echo "################################################################"
echo "Install Linux Mint themes and icons"
echo "################################################################"

echo "Download mint-x-icons..."
curl -kOL# http://packages.linuxmint.com/pool/main/m/mint-x-icons/mint-x-icons_1.7.2_all.deb
sudo apt-get -yq install ./mint-x-icons_1.7.2_all.deb
rm mint-x-icons_1.7.2_all.deb

echo "Download mint-y-icons..."
curl -kOL# http://packages.linuxmint.com/pool/main/m/mint-y-icons/mint-y-icons_1.8.3_all.deb
sudo apt-get -yq install ./mint-y-icons_1.8.3_all.deb
rm mint-y-icons_1.8.3_all.deb

echo "Download mint-l-icons..."
curl -kOL# http://packages.linuxmint.com/pool/main/m/mint-l-icons/mint-l-icons_1.7.4_all.deb
sudo apt-get -yq install ./mint-l-icons_1.7.4_all.deb
rm mint-l-icons_1.7.4_all.deb

echo "Download mint-themes..."
curl -kOL# http://packages.linuxmint.com/pool/main/m/mint-themes/mint-themes_2.2.3_all.deb
sudo apt-get -yq install ./mint-themes_2.2.3_all.deb
rm mint-themes_2.2.3_all.deb

echo "Download mint-l-theme..."
curl -kOL# http://packages.linuxmint.com/pool/main/m/mint-l-theme/mint-l-theme_1.9.9_all.deb
sudo apt-get -yq install ./mint-l-theme_1.9.9_all.deb
rm mint-l-theme_1.9.9_all.deb

echo "################################################################"
echo "Remove prespecified GTK2 icon sizes to fix scaling issues"
echo "################################################################"

sudo sed -i 's/gtk-icon-sizes.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-menu.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-button.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-small-toolbar.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dnd.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc
sudo sed -i 's/gtk-dialog.*/#/' /usr/share/themes/Mint*/gtk-2.0/gtkrc

if [ -f "/usr/bin/lxappearance" ]; then
    echo "################################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using lxappearance app"
    echo "################################################################"

    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
    sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
fi

echo "################################################################"
echo "Clone custom theming repo"
echo "################################################################"

git clone https://github.com/e33io/theming $HOME/theming-temp

echo "################################################################"
echo "Copy custom Mint Dark Mod themes"
echo "################################################################"

sudo cp -R $HOME/theming-temp/gtk/* /usr/share/themes

echo "################################################################"
echo "Install Qt and Kvantum styling packages"
echo "################################################################"

sudo apt -y install adwaita-qt* qt5-style-kvantum

if [ ! -f "/bin/lxqt-session" ]; then
    sudo apt -y install qt*ct
fi

echo "################################################################"
echo "Copy custom Kvantum Qt themes"
echo "################################################################"

sudo cp -R $HOME/theming-temp/Kvantum /usr/share

if [ -f "/usr/bin/kvantummanager" ]; then
    echo "################################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using kvantummanager app"
    echo "################################################################"

    sudo mkdir -p /root/.config/Kvantum
    sudo ln -sf $HOME/.config/Kvantum/kvantum.kvconfig /root/.config/Kvantum/kvantum.kvconfig
fi

if [ -f "/usr/bin/qt5ct" ]; then
    echo "################################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using qt5ct app"
    echo "################################################################"

    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
fi

if [ -f "/usr/bin/qt6ct" ]; then
    echo "################################################################"
    echo "Link config files to root user directories for styling"
    echo "su/root applications if using qt6ct app"
    echo "################################################################"

    sudo mkdir -p /root/.config/qt6ct
    sudo ln -sf $HOME/.config/qt6ct/qt6ct.conf /root/.config/qt6ct/qt6ct.conf
fi

echo "################################################################"
echo "Clean up user directory"
echo "################################################################"

sudo rm -Rf $HOME/theming-temp

echo "################################################################"
echo "All done, themes and icons are now installed"
echo "################################################################"
