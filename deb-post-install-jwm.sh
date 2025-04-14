#!/bin/bash

# ===========================================================================
# Debian (post-install) JWM Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-jwm.sh
# Installation steps and other configuration options: https://e33.io/1398
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the JWM window
# manager and a base set of apps for a ready-to-use desktop session.
# ---------------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors
# (192 dpi settings for 2x scaling) and desktop-type computers,
# but there are options at the end of the script that let you change
# to non-HiDPI monitors (96 dpi settings for 1x scaling),
# and/or change to laptop-type (battery powered) computer settings.
# ---------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-jwm.sh
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
echo "Install JWM and other core packages"
echo "################################################################"

sudo apt -y install jwm xfce4-panel xfce4-pulseaudio-plugin xfce4-sntray-plugin network-manager-gnome i3lock xautolock rofi dunst playerctl xsel xclip xinput x11-utils lxappearance qt5ct qt5-style-plugins adwaita-qt gnome-themes-extra papirus-icon-theme fonts-dejavu fonts-noto-color-emoji nitrogen policykit-1-gnome python3-gi gobject-introspection gir1.2-gtk-3.0 libdbus-glib-1-2 upower dex slick-greeter plymouth plymouth-themes kitty python3-pypillowfight thunar thunar-archive-plugin tumbler-plugins-extra ffmpegthumbnailer heif-thumbnailer heif-gdk-pixbuf gvfs-fuse gvfs-backends nfs-common cifs-utils engrampa pavucontrol

echo "################################################################"
echo "Install other packages"
echo "################################################################"

sudo apt -y install synaptic dconf-editor gnome-disk-utility mintstick atril imv mpv parole mousepad galculator xfce4-screenshooter flameshot gpick darktable gimp inkscape filezilla libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3 timeshift xterm htop neofetch cmus cava cmatrix ncal micro ranger ueberzug caca-utils highlight atool w3m poppler-utils mediainfo fzf libimage-exiftool-perl apt-transport-https curl rsync xdotool xbindkeys

echo "################################################################"
echo "Install pipewire and enable wireplumber service"
echo "################################################################"

sudo apt -y install pipewire-audio pipewire-media-session-
systemctl --user --now enable wireplumber.service

echo "################################################################"
echo "Install LibreWolf Web Browser"
echo "################################################################"

sudo apt update
sudo apt -y install extrepo
sudo extrepo enable librewolf
sudo apt update
sudo apt -y install librewolf

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

cp -R $HOME/dotfiles/.config $HOME
cp -R $HOME/dotfiles/.icons $HOME
cp -R $HOME/dotfiles/.local $HOME
cp -R $HOME/dotfiles/.bashrc $HOME
cp -R $HOME/dotfiles/.gtkrc* $HOME
cp -R $HOME/dotfiles/.profile $HOME
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/dotfiles/.Xresources $HOME
cp -R $HOME/opt-dots/jwm/.config $HOME
cp -R $HOME/opt-dots/jwm/.local $HOME
cp -R $HOME/opt-dots/jwm/.dmrc $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/qt5ct
sudo ln -s $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
sudo ln -s $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
sudo ln -s $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
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
echo "NOTE: The configs that were installed with this script are"
echo "based on using HiDPI monitors (192 dpi settings for 2x scaling)."
echo "The option below lets you change to non-HiDPI monitors"
echo "(96 dpi settings for 1x scaling)."
echo "----------------------------------------------------------------"

while true; do
    read -p "Do you want to change to 96 dpi settings for 1x scaling? (y/n) " yn
    case $yn in
        [Yy]* ) sh mod-dpi-scaling-wm.sh;
                echo "You chose to change to non-HiDPI settings";
                break;;
        [Nn]* ) echo "You chose to keep the default HiDPI settings";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "################################################################"
echo "NOTE: The configs that were installed with this script"
echo "are based on using a desktop-type computer."
echo "The option below lets you change to laptop configs for"
echo "use with a laptop-type (battery powered) computer."
echo "----------------------------------------------------------------"

while true; do
    read -p "Do you want to change to laptop configs? (y/n) " yn
    case $yn in
        [Yy]* ) sh mod-wm-laptop.sh;
                echo "You chose to change to laptop configs";
                break;;
        [Nn]* ) echo "You chose to keep the default desktop configs";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "################################################################"
echo "Update x-terminal-emulator and x-www-browser settings"
echo "################################################################"

sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/librewolf 201
sudo update-alternatives --set x-www-browser /usr/bin/librewolf

echo "################################################################"
echo "Add bookmarks and clean up user directory"
echo "################################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i "s/xsetroot -solid \".*\"/xsetroot -solid \"#092648\"/" $HOME/.profile
rm -R $HOME/.config/i3
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
