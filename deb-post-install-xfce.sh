#!/bin/bash

# ===========================================================================
# Debian (post-install) Xfce Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-xfce.sh
# Installation steps and other configuration options: https://e33.io/1541
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the Xfce desktop
# environment and a base set of apps for a ready-to-use desktop session.
# ---------------------------------------------------------------------------
# The default configuration is based on using 'Window Scaling 2x' for HiDPI
# monitors, but there is an option at the end of the script that lets you
# change to 'Window Scaling 1x' settings for use with non-HiDPI monitors.
# ---------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-xfce.sh
# ===========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Update and upgrade system"
echo "################################################################"

sudo apt update
sudo apt -y upgrade

echo "################################################################"
echo "Install Xfce and other core packages"
echo "################################################################"

sudo apt -y install xfce4 xfce4-terminal xfce4-power-manager xfce4-screenshooter xfce4-taskmanager xfce4-sntray-plugin thunar-archive-plugin engrampa network-manager-gnome light-locker slick-greeter gvfs-fuse gvfs-backends nfs-common cifs-utils tumbler-plugins-extra xclip mousepad menulibre gnome-themes-extra qt5ct qt5-style-plugins adwaita-qt papirus-icon-theme fonts-noto-color-emoji plymouth plymouth-themes

echo "################################################################"
echo "Install other packages"
echo "################################################################"

sudo apt -y install atril ristretto parole rhythmbox galculator gnome-disk-utility mintstick synaptic gpick darktable gimp inkscape filezilla libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3 timeshift xterm micro imv mpv htop neofetch cmus cava cmatrix ncal ranger ueberzug caca-utils highlight atool w3m poppler-utils mediainfo fzf heif-thumbnailer heif-gdk-pixbuf libimage-exiftool-perl apt-transport-https curl rsync wmctrl xdotool xbindkeys

echo "################################################################"
echo "Install pipewire and enable wireplumber service"
echo "################################################################"

sudo apt -y install pipewire-audio pipewire-media-session-
systemctl --user --now enable wireplumber.service

echo "################################################################"
echo "Install Brave Browser"
echo "################################################################"

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt -y install brave-browser

echo "################################################################"
echo "Install Signal App"
echo "################################################################"

curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt -y install signal-desktop

echo "################################################################"
echo "Clone custom configuration files"
echo "################################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "################################################################"
echo "Copy custom configuration files"
echo "################################################################"

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/opt-dots/xfce/.config $HOME
cp -R $HOME/opt-dots/xfce/.local $HOME
cp -R $HOME/opt-dots/xfce/.bashrc $HOME
cp -R $HOME/opt-dots/xfce/.profile $HOME
cp -R $HOME/opt-dots/xfce/.Xresources $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo cp -R $HOME/opt-dots/xfce/usr/bin /usr
sudo cp -R $HOME/opt-dots/xfce/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/qt5ct
sudo ln -s $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
sudo ln -sf /usr/share/wallpapers/background.png /usr/share/images/desktop-base/default
sudo update-initramfs -u
sudo update-grub

echo "################################################################"
echo "Add user .bash_profile and .xsessionrc files"
echo "################################################################"

echo "if [ -f ~/.profile ]; then
    . ~/.profile
fi" | tee $HOME/.bash_profile $HOME/.xsessionrc > /dev/null

echo "################################################################"
echo "Update root .bashrc file"
echo "################################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc > /dev/null

echo "################################################################"
echo "Remove unneeded default xsession file if it exists"
echo "################################################################"

if [ -f "/usr/share/xsessions/lightdm-xsession.desktop" ]; then
    sudo rm -R /usr/share/xsessions/lightdm-xsession.desktop
fi

clear
while true; do
    echo "################################################################"
    echo "The option below lets you select a configuration specific"
    echo "to your monitor type for proper display scaling."
    echo "################################################################"
    echo "   1) Standard HD (96 dpi settings for 'Window Scaling 1x')"
    echo "   2) HiDPI (192 dpi settings for 'Window Scaling 2x')"
    echo "----------------------------------------------------------------"

    read -p "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh mod-dpi-scaling-xfce.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "################################################################"
echo "Update x-www-browser settings"
echo "################################################################"

sudo update-alternatives --set x-www-browser /usr/bin/brave-browser-stable

echo "################################################################"
echo "Add bookmarks and clean up user directory"
echo "################################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
