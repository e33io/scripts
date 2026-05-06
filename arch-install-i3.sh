#!/bin/bash

# =============================================================================
# Install i3 (window manager) on Arch Linux
# URL: https://github.com/e33io/scripts/blob/main/arch-install-i3.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Works best with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the i3 window manager and a base set of apps for a
# ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-install-i3.sh
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! Do not run this script as root!"
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
echo "Install i3 and other packages"
echo "========================================================================"

sudo pacman -S --noconfirm --needed xorg-server xorg-apps i3-wm i3status i3lock xss-lock polybar \
dmenu rofi dunst base-devel upower gvfs nfs-utils cifs-utils wireplumber libmad gst-libav rsync cronie \
git curl wget tar less 7zip xsel xclip xbindkeys xdotool yt-dlp playerctl dex xdg-desktop-portal-gtk \
xdg-user-dirs mate-polkit lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings feh lxappearance \
gnome-themes-extra qt5ct qt6ct kvantum kvantum-qt5 ttf-dejavu noto-fonts noto-fonts-cjk noto-fonts-emoji \
papirus-icon-theme breeze-icons plymouth pavucontrol-qt kitty python-pillowfight xterm bash-completion \
vim nano micro fzf lazygit htop fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo \
perl-image-exiftool thunar thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer xarchiver \
atril scrot imagemagick imv mpv parole mousepad galculator timeshift signal-desktop gpick darktable \
gimp inkscape filezilla libreoffice

echo "========================================================================"
echo "Install graphics drivers"
echo "========================================================================"

bash ~/scripts/install-gpu-packages.sh

if ! command -v yay > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Setup Yay for AUR"
    echo "========================================================================"

    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    (cd ~/yay-bin && makepkg -si --noconfirm)
    rm -rf ~/yay-bin
fi

echo "========================================================================"
echo "Install packages from AUR"
echo "========================================================================"

yay -S --noconfirm --needed --sudoloop xssproxy mintstick brave-bin

echo "========================================================================"
echo "Set boot target to graphical UI and enable system services"
echo "========================================================================"

sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service
sudo systemctl enable cronie.service

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/dots ~/dots

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

cp -R ~/dots/home/.??* ~/
sudo cp -R ~/dots/root/* /
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/{gtk-3.0,micro,qt5ct,qt6ct}
for dir in gtk-3.0 micro qt5ct qt6ct; do
    sudo ln -sf ~/.config/$dir/* /root/.config/$dir/
done

echo "========================================================================"
echo "Install custom themes"
echo "========================================================================"

bash ~/scripts/install-custom-themes.sh

echo "========================================================================"
echo "Run system detect script to update device-specific configuration files"
echo "========================================================================"

bash ~/scripts/system-detect.sh

echo "========================================================================"
echo "Update and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
sed -i "s/\/user\//\/$(whoami)\//" ~/.config/gtk-3.0/bookmarks \
~/.gtkrc-2.0 ~/.config/qt5ct/qt5ct.conf ~/.config/qt6ct/qt6ct.conf \
~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml 2>/dev/null
echo "i3 installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/dots ~/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
