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
# NOTE: Default COSMIC theming is used, custom theming configs are WIP
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

sudo pacman -S --noconfirm --needed cosmic system76-scheduler system76-firmware power-profiles-daemon \
plymouth papirus-icon-theme breeze-icons xdg-desktop-portal-gtk xdg-user-dirs gvfs gvfs-nfs gvfs-smb \
nfs-utils cifs-utils libmad rsync cronie git curl wget tar 7zip less base-devel bash-completion vim \
nano micro fzf lazygit htop fastfetch cmus cava ranger highlight atool w3m mediainfo perl-image-exiftool \
kitty python-pillowfight imv mpv timeshift gnome-disk-utility dconf-editor file-roller gthumb evince \
rhythmbox signal-desktop darktable gimp inkscape filezilla libreoffice

pc_type="$(hostnamectl chassis)"
if [ "$pc_type" = vm ]; then
    sudo pacman -S --noconfirm --needed spice-vdagent
fi

echo "========================================================================"
echo "Install graphics drivers"
echo "========================================================================"

bash ~/scripts/install-gpu-packages.sh

if ! command -v yay > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Setup Yay for AUR"
    echo "========================================================================"

    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    cd ~/yay-bin
    makepkg -si --noconfirm
    cd
    rm -rf ~/yay-bin
fi

echo "========================================================================"
echo "Install other packages from AUR"
echo "========================================================================"

yay -S --noconfirm --needed --sudoloop mintstick brave-bin

echo "========================================================================"
echo "Set boot target to graphical UI and enable system services"
echo "========================================================================"

sudo systemctl set-default graphical.target
sudo systemctl enable cosmic-greeter.service
sudo systemctl enable cronie.service

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/core ~/core
git clone https://github.com/e33io/extra ~/extra

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

cp -R ~/extra/cosmic/home/.??* ~/
cp -R ~/extra/cosmic/arch/home/.??* ~/
sudo cp -R ~/core/root/* /
sudo cp -R /usr/share/wallpapers/* /usr/share/backgrounds
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/micro
sudo ln -sf ~/.config/micro/* /root/.config/micro

echo "========================================================================"
echo "Change Papirus folders color"
echo "========================================================================"

if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi
papirus-folders -C darkcyan --theme Papirus-Light
papirus-folders -C darkcyan --theme Papirus-Dark

echo "========================================================================"
echo "Update and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
echo "COSMIC installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/core
rm -rf ~/extra
rm -rf ~/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
