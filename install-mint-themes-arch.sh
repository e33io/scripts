#!/bin/bash

# ===========================================================================
# Install Linux Mint Themes and Icons
# URL: https://github.com/e33io/scripts/blob/main/install-mint-themes-arch.sh
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Arch Linux!
# ===========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

if [ ! -f "/etc/pacman.conf" ]; then
    echo "################################################################"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Arch Linux, and it will exit now"
    echo "without running or making any changes."
    echo "################################################################"
    exit 1
fi

if ! command -v yay &>/dev/null; then
    echo "################################################################"
    echo "Setup Yay for AUR"
    echo "################################################################"
    
    git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
    cd $HOME/yay-bin
    makepkg -si --noconfirm
    cd
    rm -Rf $HOME/yay-bin
fi

echo "################################################################"
echo "Install Mint themes and dependencies"
echo "################################################################"

sudo pacman -Syu
sudo pacman -S --noconfirm --needed gnome-themes-extra gtk-engine-murrine less git

yay -S --noconfirm --needed --sudoloop mint-x-icons mint-y-icons mint-l-icons mint-themes mint-l-theme

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

sudo pacman -S --noconfirm --needed kvantum kvantum-qt5

if [ ! -f "/lib/qt/plugins/styles/adwaita.so" ]; then
    yay -S --noconfirm --needed --sudoloop adwaita-qt5-git adwaita-qt6-git
fi

if [ ! -f "/bin/lxqt-session" ]; then
    sudo pacman -S --noconfirm --needed qt5ct qt6ct
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
    echo "su/root applications if using qt5ct and/or qt6ct app"
    echo "################################################################"

    sudo mkdir -p /root/.config/qt5ct
    sudo mkdir -p /root/.config/qt6ct
    sudo ln -sf $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
    sudo ln -sf $HOME/.config/qt6ct/qt6ct.conf /root/.config/qt6ct/qt6ct.conf
fi

echo "################################################################"
echo "Clean up user directory"
echo "################################################################"

sudo rm -Rf $HOME/theming-temp

echo "################################################################"
echo "All done, themes and icons are now installed"
echo "################################################################"
