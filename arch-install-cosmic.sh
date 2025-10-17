#!/bin/bash

# =============================================================================
# Arch Linux - Install COSMIC (desktop environment)
# URL: https://github.com/e33io/scripts/blob/main/arch-install-cosmic.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Works best with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the COSMIC desktop environment and a base set of apps for
# a ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-install-cosmic.sh
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

echo "========================================================================"
echo "Update package list and upgrade system"
echo "========================================================================"

sudo pacman -Syu --noconfirm

echo "========================================================================"
echo "Install COSMIC and other packages"
echo "========================================================================"

sudo pacman -S --noconfirm --needed cosmic plymouth papirus-icon-theme breeze-icons \
xdg-desktop-portal-gtk xdg-user-dirs gvfs gvfs-nfs gvfs-smb nfs-utils cifs-utils fuse rsync \
cronie git curl wget tar 7zip less base-devel bash-completion vim nano micro fzf lazygit htop \
fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo perl-image-exiftool mpv \
timeshift signal-desktop darktable gimp inkscape filezilla libreoffice

if ! command -v yay > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Setup Yay for AUR"
    echo "========================================================================"

    git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
    cd $HOME/yay-bin
    makepkg -si --noconfirm
    cd
    rm -rf $HOME/yay-bin
fi

echo "========================================================================"
echo "Install other packages from AUR"
echo "========================================================================"

yay -S --noconfirm --needed --sudoloop mintstick brave-bin

echo "========================================================================"
echo "Enable cosmic-greeter"
echo "========================================================================"

sudo systemctl set-default graphical.target
sudo systemctl enable cosmic-greeter.service

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/extra $HOME/extra

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/dotfiles/usr/share/grub /usr/share
sudo cp -R $HOME/dotfiles/usr/share/wallpapers /usr/share
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/micro
sudo ln -sf $HOME/.config/micro/* /root/.config/micro

if [ ! -f "$HOME/.install-info" ]; then
    echo "========================================================================"
    echo "Update root .bashrc file"
    echo "========================================================================"

    printf '%s\n' '' '# Set command prompt' 'PS1="\[\e[01;31m\]\u \w/#\[\e[m\] "' \
    | sudo tee -a /root/.bashrc > /dev/null
fi

echo "========================================================================"
echo "Change Papirus folders color"
echo "========================================================================"

if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi
papirus-folders -C darkcyan --theme Papirus-Light
papirus-folders -C darkcyan --theme Papirus-Dark

echo "========================================================================"
echo "Clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
echo "COSMIC installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a $HOME/.install-info > /dev/null
rm -rf $HOME/dotfiles
rm -rf $HOME/extra
rm -rf $HOME/scripts

echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
