#!/bin/bash

# =============================================================================
# Arch Linux - Install i3 (tiling window manager)
# URL: https://github.com/e33io/scripts/blob/main/arch-install-i3.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Works best with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the i3 window manager and a base set of apps for a
# ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-install-i3.sh
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
echo "Install i3 and other packages"
echo "========================================================================"

sudo pacman -S --noconfirm --needed xorg-server xorg-apps i3-wm i3status i3lock xss-lock polybar \
dmenu rofi dunst base-devel upower gvfs nfs-utils cifs-utils wireplumber libmad gst-libav rsync cronie \
git curl wget tar less 7zip xsel xclip xbindkeys xdotool playerctl dex xdg-desktop-portal-gtk xdg-user-dirs \
mate-polkit lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings feh lxappearance gnome-themes-extra \
qt5ct qt6ct ttf-dejavu noto-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme breeze-icons plymouth \
pavucontrol-qt kitty python-pillowfight xterm bash-completion vim nano micro fzf lazygit htop fastfetch \
cmus cava ranger ueberzug highlight atool w3m mediainfo perl-image-exiftool thunar thunar-archive-plugin \
thunar-volman tumbler ffmpegthumbnailer xarchiver scrot atril imv mpv parole mousepad galculator \
timeshift signal-desktop gpick darktable gimp inkscape filezilla libreoffice

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
echo "Install packages from AUR"
echo "========================================================================"

yay -S --noconfirm --needed --sudoloop xssproxy adwaita-qt5 adwaita-qt6 mintstick brave-bin

echo "========================================================================"
echo "Set boot target to graphical UI and enable system services"
echo "========================================================================"

sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service
sudo systemctl enable cronie.service

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/core ~/core

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

cp -R ~/core/home/.??* ~/
cp -R ~/core/arch/home/.??* ~/
cp -R ~/scripts/set-theming-i3.sh ~/.local/bin/set-theming-i3
sudo cp -R ~/core/root/* /
sudo cp -R ~/core/arch/root/* /
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/{gtk-3.0,micro,qt5ct,qt6ct}
for dir in gtk-3.0 micro qt5ct qt6ct; do
    sudo ln -sf ~/.config/$dir/* /root/.config/$dir/
done

echo "========================================================================"
echo "Install custom themes and change Papirus folders color"
echo "========================================================================"

sh ~/scripts/install-custom-themes.sh
if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
    papirus-folders -C adwaita --theme Papirus-Dark
fi

clear
while true; do
    echo "========================================================================"
    echo "The option below lets you select a configuration specific"
    echo "to your monitor type for proper display scaling."
    echo "========================================================================"
    echo "  1) Standard HD (96 dpi settings for 1x scaling)"
    echo "  2) HiDPI (192 dpi settings for 2x scaling)"
    echo "------------------------------------------------------------------------"

    read -rp "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh ~/scripts/mod-dpi-scaling-wm.sh;
           sudo sed -i 's/^greeter-wrapper/#greeter-wrapper/' /etc/lightdm/lightdm.conf;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

pc_type="$(hostnamectl chassis)"
if [ "$pc_type" = laptop ] || [ "$pc_type" = notebook ] \
    || [ "$pc_type" = portable ]; then
    echo "========================================================================"
    echo "Modify window manager configs for laptop use"
    echo "========================================================================"

    sh ~/scripts/mod-wm-laptop.sh
elif [ "$pc_type" = vm ]; then
    echo "========================================================================"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "========================================================================"

    sh ~/scripts/mod-virt-machines.sh
fi

echo "========================================================================"
echo "Update and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
sed -i "s/\/user\//\/$(whoami)\//" ~/.config/gtk-3.0/bookmarks ~/.gtkrc-2.0 \
~/.config/qt5ct/qt5ct.conf ~/.config/qt6ct/qt6ct.conf \
~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's/"top": 1,/"top": 0,/' ~/.config/fastfetch/config.jsonc
sed -i 's/brave-browser/brave/' ~/.config/i3/config
sed -i -e '/libexec/d' -e 's/#\$exec .* xbindkeys/$exec xbindkeys/' \
-e 's/#\$exec .* \/usr/$exec \/usr/' ~/.config/i3/startup.conf
echo "i3 installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/core
rm -rf ~/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
