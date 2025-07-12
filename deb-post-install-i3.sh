#!/bin/bash

# ========================================================================
# Debian (post-install) i3 Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-i3.sh
# Installation steps and other configuration options: https://e33.io/1121
# ------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the i3 window
# manager and a base set of apps for a ready-to-use desktop session.
# ------------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors
# (192 dpi settings for 2x scaling), but there is an option
# at the end of the script that lets you change to standard
# HD monitors (96 dpi settings for 1x scaling).
# ------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-i3.sh
# ========================================================================

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
echo "Install i3 and other core packages"
echo "################################################################"

sudo apt -y install i3 python3-i3ipc py3status rofi network-manager playerctl xssproxy xsel xclip xinput x11-utils \
lxappearance qt*ct adwaita-qt* gnome-themes-extra papirus-icon-theme breeze-icon-theme fonts-dejavu \
fonts-noto-color-emoji nitrogen mate-polkit-bin python3-gi gobject-introspection gir1.2-gtk-3.0 libdbus-glib-1-2 \
upower lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings plymouth plymouth-themes kitty python3-pypillowfight \
thunar thunar-archive-plugin tumbler-plugins-extra ffmpegthumbnailer heif-thumbnailer heif-gdk-pixbuf gvfs-fuse \
gvfs-backends nfs-common cifs-utils engrampa pavucontrol-qt

echo "################################################################"
echo "Install other packages"
echo "################################################################"

sudo apt -y install synaptic dconf-editor dconf-cli gnome-disk-utility mintstick scrot atril imv mpv parole mousepad \
galculator gpick darktable gimp inkscape filezilla libreoffice-calc libreoffice-draw libreoffice-impress \
libreoffice-writer libreoffice-gtk3 timeshift xterm htop neofetch cmus cava cmatrix ncal micro ranger ueberzug \
caca-utils highlight atool w3m poppler-utils mediainfo fzf libimage-exiftool-perl apt-transport-https curl rsync \
xdotool xbindkeys

echo "################################################################"
echo "Install pipewire and enable wireplumber service"
echo "################################################################"

sudo apt -y install pipewire-audio pipewire-media-session-
systemctl --user --now enable wireplumber.service

echo "################################################################"
echo "Install Brave Browser"
echo "################################################################"

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
https://brave-browser-apt-release.s3.brave.com/ stable main" \
| sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt -y install brave-browser

echo "################################################################"
echo "Install Signal App"
echo "################################################################"

curl -fsSL https://updates.signal.org/desktop/apt/keys.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] \
https://updates.signal.org/desktop/apt xenial main" \
| sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt -y install signal-desktop

echo "################################################################"
echo "Clone custom configuration files"
echo "################################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles

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
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/micro
sudo mkdir -p /root/.config/qt5ct
sudo mkdir -p /root/.config/qt6ct
sudo ln -sf $HOME/.config/gtk-3.0/* /root/.config/gtk-3.0
sudo ln -sf $HOME/.config/micro/* /root/.config/micro
sudo ln -sf $HOME/.config/qt5ct/* /root/.config/qt5ct
sudo ln -sf $HOME/.config/qt6ct/* /root/.config/qt6ct
sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
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
    sudo rm -rf /usr/share/xsessions/lightdm-xsession.desktop
fi

clear
while true; do
    echo "################################################################"
    echo "The option below lets you select a configuration specific"
    echo "to your monitor type for proper display scaling."
    echo "################################################################"
    echo "   1) Standard HD (96 dpi settings for 1x scaling)"
    echo "   2) HiDPI (192 dpi settings for 2x scaling)"
    echo "----------------------------------------------------------------"

    read -p "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh mod-dpi-scaling-wm.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

pc_type="$(hostnamectl chassis)"
if [ $pc_type = laptop ]; then
    echo "################################################################"
    echo "Modify window manager configs for laptop use"
    echo "################################################################"

    sh mod-wm-laptop.sh
fi
if [ $pc_type = vm ]; then
    echo "################################################################"
    echo "Install spice-vdagent and update lightdm scaling"
    echo "################################################################"

    sudo apt -y install spice-vdagent
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

if [ -f "/etc/devuan_version" ]; then
    echo "################################################################"
    echo "Update Debian configs for use with Devuan Linux"
    echo "################################################################"

    sh mod-debian-to-devuan.sh
fi

echo "################################################################"
echo "Update x-terminal-emulator and x-www-browser settings"
echo "################################################################"

sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
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
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
rm -rf $HOME/dotfiles
rm -rf $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
