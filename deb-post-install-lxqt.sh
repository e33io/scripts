#!/bin/bash

# ============================================================================
# Debian (post-install) LXQt Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-lxqt.sh
# ----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the LXQt desktop
# environment and a base set of apps for a ready-to-use desktop session.
# ----------------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors (192 dpi settings),
# but there is an option at the end of the script that lets you change to
# 96 dpi settings for use with standard non-HiDPI monitors.
# ----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-lxqt.sh
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
echo "Update and upgrade"
echo "#########################################################"

sudo apt update
sudo apt -y upgrade

echo "#########################################################"
echo "Install LXQt and other core packages"
echo "#########################################################"

sudo apt -y install lxqt-core slick-greeter engrampa network-manager-gnome xterm playerctl libnotify-bin nfs-common cifs-utils adwaita-qt fonts-dejavu fonts-noto-color-emoji plymouth plymouth-themes

echo "#########################################################"
echo "Install other packages"
echo "#########################################################"

sudo apt -y install synaptic gnome-disk-utility mintstick atril imv mpv parole pragha galculator flameshot gpick darktable gimp inkscape filezilla libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3 timeshift dunst rofi htop neofetch cmus cava cmatrix ncal micro ranger ueberzug caca-utils highlight atool w3m poppler-utils mediainfo fzf heif-thumbnailer libimage-exiftool-perl apt-transport-https curl rsync xdotool xbindkeys

echo "#########################################################"
echo "Install pipewire and enable wireplumber service"
echo "#########################################################"

sudo apt -y install pipewire-audio pipewire-media-session-
systemctl --user --now enable wireplumber.service

echo "#########################################################"
echo "Install Firefox Browser"
echo "#########################################################"

curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/packages.mozilla.org.gpg
echo "deb [signed-by=/usr/share/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list
echo "Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla > /dev/null
sudo apt update
sudo apt -y install firefox

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
mkdir -p $HOME/.config/rofi
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.config/rofi $HOME/.config
cp -R $HOME/dotfiles/.icons $HOME
cp -R $HOME/dotfiles/.gtkrc* $HOME
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/dotfiles/.Xresources $HOME
cp -R $HOME/opt-dots/lxqt/.config $HOME
cp -R $HOME/opt-dots/lxqt/.local $HOME
cp -R $HOME/opt-dots/lxqt/.bashrc $HOME
cp -R $HOME/opt-dots/lxqt/.profile $HOME
cp -R $HOME/opt-dots/lxqt/.xscreensaver $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo cp -R $HOME/opt-dots/lxqt/usr/share /usr
sudo cp -R $HOME/opt-dots/xfce/usr/bin /usr
sudo cp -R $HOME/opt-dots/xfce/usr/share/themes /usr/share
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/lxqt
sudo ln -s $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
sudo ln -s $HOME/.config/lxqt/lxqt.conf /root/.config/lxqt/lxqt.conf
sudo ln -s $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
sudo update-initramfs -u
sudo update-grub

echo "#########################################################"
echo "Add .bash_profile and .xsessionrc files"
echo "#########################################################"

echo "if [ -f ~/.profile ]; then
    . ~/.profile
fi" | tee $HOME/.bash_profile $HOME/.xsessionrc >/dev/null

echo "#########################################################"
echo "Update root .bashrc file"
echo "#########################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc >/dev/null

echo "#########################################################"
echo "Remove unneeded default xsession file if it exists"
echo "#########################################################"

if [ -f "/usr/share/xsessions/lightdm-xsession.desktop" ]; then
    sudo rm -R /usr/share/xsessions/lightdm-xsession.desktop
fi

echo "#########################################################"
echo "NOTE: The configs that were installed with this script"
echo "are based on using HiDPI monitors (192 dpi settings)."
echo "The option below lets you change to 96 dpi settings for"
echo "use with standard non-HiDPI monitors."
echo "---------------------------------------------------------"

while true; do
    read -p "Do you want to change to 96 dpi non-HiDPI settings? (y/n) " yn
    case $yn in
        [Yy]* ) sh mod-dpi-scaling-lxqt.sh;
                echo "You chose to change to non-HiDPI settings";
                break;;
        [Nn]* ) echo "You chose to keep the default HiDPI settings";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "#########################################################"
echo "Update x-www-browser settings"
echo "#########################################################"

sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/lib/firefox/firefox 210
sudo update-alternatives --set x-www-browser /usr/lib/firefox/firefox

echo "#########################################################"
echo "Clean up user directory"
echo "#########################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.gtk-bookmarks
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
