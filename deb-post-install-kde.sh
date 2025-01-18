#!/bin/bash

# =======================================================================
# Debian (post-install) KDE Plasma Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-kde.sh
# -----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the
# KDE Plasma desktop environment and a base set of apps for a
# ready-to-use desktop session.
# -----------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-kde.sh
# =======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

if ! { grep 'trixie' /etc/debian_version || grep 'sid' /etc/debian_version; }; then
    echo "#########################################################"
    echo "This script is NOT compatible with your version of Debian!"
    echo "It only works with Debian Sid/unstable, and it will"
    echo "exit now without running."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Update and upgrade"
echo "#########################################################"

sudo apt update
sudo apt -y upgrade

echo "#########################################################"
echo "Install KDE Plasma and other core packages"
echo "#########################################################"

sudo apt -y install kde-plasma-desktop plasma-nm sddm-theme-breeze ark gwenview okular kde-spectacle kcalc kcolorchooser kate elisa vlc fonts-noto-color-emoji plymouth plymouth-themes xterm gvfs-fuse gvfs-backends nfs-common cifs-utils

echo "#########################################################"
echo "Install other packages"
echo "#########################################################"

sudo apt -y install synaptic darktable gimp inkscape kdenlive filezilla libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-k* gnome-disk-utility mintstick timeshift mpv micro htop neofetch cmus cava cmatrix fzf libimage-exiftool-perl apt-transport-https curl rsync xdotool xbindkeys

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
sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/lib/firefox/firefox 210
sudo update-alternatives --set x-www-browser /usr/lib/firefox/firefox

echo "#########################################################"
echo "Install Signal App"
echo "#########################################################"

curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt -y install signal-desktop

echo "#########################################################"
echo "Clone custom dotfiles"
echo "#########################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "#########################################################"
echo "Copy custom files"
echo "#########################################################"

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/opt-dots/kde/.config $HOME
cp -R $HOME/opt-dots/kde/.local $HOME
cp -R $HOME/opt-dots/kde/.bashrc $HOME
cp -R $HOME/opt-dots/kde/.gtkrc-2.0 $HOME
cp -R $HOME/opt-dots/kde/.profile $HOME
cp -R $HOME/opt-dots/kde/.Xresources $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
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
echo "Clean up user directory"
echo "#########################################################"

mkdir -p $HOME/Desktop
mkdir -p $HOME/Documents
mkdir -p $HOME/Downloads
mkdir -p $HOME/Music
mkdir -p $HOME/Pictures
mkdir -p $HOME/Videos
sed -i "s/e33/$(whoami)/g" $HOME/.config/ksmserverrc
sed -i "s/e33/$(whoami)/g" $HOME/.config/ktrashrc
sed -i "s/e33/$(whoami)/g" $HOME/.config/session/dolphin_dolphin_dolphin
sed -i "s/e33/$(whoami)/g" $HOME/.local/share/recently-used.xbel
sed -i "s/e33/$(whoami)/g" $HOME/.local/share/user-places.xbel
sed -i "s/e33/$(whoami)/g" $HOME/.local/share/user-places.xbel.bak
sudo rm /usr/share/applications/imv-folder.desktop
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
