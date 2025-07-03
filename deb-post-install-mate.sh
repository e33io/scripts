#!/bin/bash

# ===========================================================================
# Debian (post-install) MATE Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-mate.sh
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the MATE desktop
# environment and a base set of apps for a ready-to-use desktop session.
# ---------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-mate.sh
# ===========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Update and upgrade system"
echo "#########################################################"

sudo apt update
sudo apt -y upgrade

echo "#########################################################"
echo "Install MATE and other core packages"
echo "#########################################################"

sudo apt -y install mate-desktop-environment mate-desktop-environment-extras mate-media caja-mediainfo caja-actions network-manager-gnome \
ayatana-indicator-application ayatana-indicator-keyboard ayatana-indicator-messages ayatana-indicator-notifications ayatana-indicator-power \
ayatana-indicator-printers ayatana-indicator-session ayatana-indicator-sound ayatana-settings slick-greeter gnome-themes-extra qt*ct \
adwaita-qt* papirus-icon-theme fonts-noto-color-emoji plank kitty python3-pypillowfight nfs-common cifs-utils xclip plymouth plymouth-themes

echo "#########################################################"
echo "Install other packages"
echo "#########################################################"

sudo apt -y install xfce4-appfinder parole mpv rhythmbox gnome-disk-utility mintstick synaptic darktable gimp inkscape filezilla \
libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3 timeshift dconf-editor dconf-cli heif-thumbnailer \
heif-gdk-pixbuf micro htop neofetch cmus cava cmatrix ncal micro ranger ueberzug caca-utils highlight atool w3m poppler-utils mediainfo fzf \
libimage-exiftool-perl apt-transport-https curl rsync xdotool xbindkeys

echo "#########################################################"
echo "Install pipewire and enable wireplumber service"
echo "#########################################################"

sudo apt -y install pipewire-audio pipewire-media-session-
systemctl --user --now enable wireplumber.service

echo "#########################################################"
echo "Run install-yaru-themes.sh script to"
echo "install Yaru themes and icons"
echo "#########################################################"

sh install-yaru-themes.sh

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

echo "#########################################################"
echo "Clone custom configuration files"
echo "#########################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "#########################################################"
echo "Copy custom configuration files"
echo "#########################################################"

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/opt-dots/mate/.config $HOME
cp -R $HOME/opt-dots/mate/.local $HOME
cp -R $HOME/opt-dots/mate/.bashrc $HOME
cp -R $HOME/opt-dots/mate/.profile $HOME
cp -R $HOME/opt-dots/mate/.Xresources $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo cp -R $HOME/opt-dots/mate/etc/lightdm /etc
sudo cp -R $HOME/opt-dots/mate/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/qt5ct
sudo mkdir -p /root/.config/qt6ct
sudo ln -sf $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
sudo ln -sf $HOME/.config/qt6ct/qt6ct.conf /root/.config/qt6ct/qt6ct.conf
sudo update-initramfs -u
sudo update-grub

echo "#########################################################"
echo "Add user .bash_profile and .xsessionrc files"
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
echo "Remove unneeded default xsession file"
echo "#########################################################"

sudo rm -rf /usr/share/xsessions/lightdm-xsession.desktop

echo "#########################################################"
echo "Change Papirus folders color"
echo "#########################################################"

wget -qO- https://git.io/papirus-folders-install | sh
papirus-folders -C yaru --theme Papirus-Dark

echo "#########################################################"
echo "Modify Plank dock theme"
echo "#########################################################"

echo "IndicatorSize=6" | sudo tee -a /usr/share/plank/themes/Transparent/dock.theme

pc_type="$(hostnamectl chassis)"
if [ $pc_type = vm ]; then
    echo "################################################################"
    echo "Install spice-vdagent"
    echo "################################################################"

    sudo apt -y install spice-vdagent
fi

echo "################################################################"
echo "Update x-www-browser settings"
echo "################################################################"

sudo update-alternatives --set x-www-browser /usr/bin/brave-browser-stable

echo "#########################################################"
echo "Add bookmarks, add wallpaper and clean up user directory"
echo "#########################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sudo wget -q https://i.e33.io/wp/rancho-twilight-4k.jpg -P /usr/share/backgrounds
dconf write /org/mate/desktop/background/picture-filename "'/usr/share/backgrounds/rancho-twilight-4k.jpg'"
dconf write /org/mate/screensaver/picture-filename "'/usr/share/backgrounds/rancho-twilight-4k.jpg'"
sudo rm -rf /usr/share/applications/imv-folder.desktop
rm -rf $HOME/dotfiles
rm -rf $HOME/opt-dots
rm -rf $HOME/scripts

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
