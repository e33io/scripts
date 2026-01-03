#!/bin/bash

# =============================================================================
# Arch Linux - Install Xfce (desktop environment)
# URL: https://github.com/e33io/scripts/blob/main/arch-install-xfce.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Works best with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the Xfce desktop environment and a base set of apps for a
# ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-install-xfce.sh
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
echo "Install Xfce and other packages"
echo "========================================================================"

sudo pacman -S --noconfirm --needed xfce4 xfce4-screensaver xfce4-screenshooter xfce4-taskmanager \
xfce4-notifyd xfce4-battery-plugin xfce4-pulseaudio-plugin xfce4-docklike-plugin xfce4-windowck-plugin \
thunar-archive-plugin network-manager-applet ffmpegthumbnailer base-devel gvfs nfs-utils cifs-utils \
wireplumber libmad gst-libav rsync cronie git curl wget tar 7zip less xsel xclip xdg-desktop-portal-gtk \
xdg-user-dirs xiccd xorg-apps wmctrl xdotool xbindkeys plymouth lightdm lightdm-gtk-greeter \
lightdm-gtk-greeter-settings gnome-themes-extra qt5ct qt6ct ttf-dejavu noto-fonts noto-fonts-cjk \
noto-fonts-emoji papirus-icon-theme breeze-icons pavucontrol xarchiver atril ristretto imv mpv parole \
rhythmbox mousepad galculator dconf-editor gnome-disk-utility timeshift xterm bash-completion vim nano \
micro fzf lazygit htop fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo \
perl-image-exiftool signal-desktop gpick darktable gimp inkscape filezilla libreoffice

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

yay -S --noconfirm --needed --sudoloop menulibre adwaita-qt5 adwaita-qt6 mintstick brave-bin

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
git clone https://github.com/e33io/extra ~/extra

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

mkdir -p ~/.local/bin
cp -R ~/extra/xfce/home/.??* ~/
cp -R ~/extra/xfce/arch/home/.??* ~/
cp -R ~/scripts/set-theming-xfce.sh ~/.local/bin/set-theming-xfce
sudo cp -R ~/core/root/* /
sudo cp -R ~/extra/xfce/root/* /
sudo cp -R ~/extra/xfce/arch/root/* /
sudo cp -R ~/scripts/window-control.sh /usr/bin
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/{micro,qt5ct,qt6ct}
for dir in micro qt5ct qt6ct; do
    sudo ln -sf ~/.config/$dir/* /root/.config/$dir/
done
sudo mv /usr/share/backgrounds/xfce/xfce-x.svg /usr/share/backgrounds/xfce/xfce-default.svg
sudo ln -sf /usr/share/wallpapers/background-0.png /usr/share/backgrounds/xfce/xfce-x.svg

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
    echo "  1) Standard HD (96 dpi settings for 'Window Scaling 1x')"
    echo "  2) HiDPI (192 dpi settings for 'Window Scaling 2x')"
    echo "------------------------------------------------------------------------"

    read -rp "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh ~/scripts/mod-dpi-scaling-xfce.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

pc_type="$(hostnamectl chassis)"
if [ "$pc_type" = vm ]; then
    echo "========================================================================"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "========================================================================"

    sh ~/scripts/mod-virt-machines.sh
fi

echo "========================================================================"
echo "Update and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
sed -i "s/home\/.*\//home\/$(whoami)\//" ~/.config/gtk-3.0/bookmarks \
~/.config/qt5ct/qt5ct.conf ~/.config/qt6ct/qt6ct.conf \
~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's/"top": 1,/"top": 0,/' ~/.config/fastfetch/config.jsonc
echo "Xfce installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/core
rm -rf ~/extra
rm -rf ~/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
