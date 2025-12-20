#!/bin/bash

# =============================================================================
# Arch Linux - Install dk (tiling window manager)
# URL: https://github.com/e33io/scripts/blob/main/arch-install-dk.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Works best with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the dk window manager and a base set of apps for a
# ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-install-dk.sh
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
echo "Install Xorg and other packages"
echo "========================================================================"

sudo pacman -S --noconfirm --needed xorg-server xorg-apps sxhkd polybar i3lock xss-lock dmenu rofi \
dunst base-devel upower gvfs nfs-utils cifs-utils wireplumber libmad gst-libav rsync cronie git curl \
wget tar less 7zip xsel xclip xbindkeys xdotool playerctl dex xdg-desktop-portal-gtk xdg-user-dirs \
mate-polkit lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings feh lxappearance gnome-themes-extra \
qt5ct qt6ct ttf-dejavu noto-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme breeze-icons \
plymouth pavucontrol-qt kitty python-pillowfight xterm bash-completion vim nano micro fzf lazygit \
htop fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo perl-image-exiftool thunar \
thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer xarchiver scrot atril imv mpv parole \
mousepad galculator timeshift signal-desktop gpick darktable gimp inkscape filezilla libreoffice

echo "========================================================================"
echo "Install graphics drivers"
echo "========================================================================"

bash $HOME/scripts/install-gpu-packages.sh

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
echo "Install dk and other packages from AUR"
echo "========================================================================"

yay -S --noconfirm --needed --sudoloop dk xssproxy adwaita-qt5 adwaita-qt6 mintstick brave-bin

echo "========================================================================"
echo "Set boot target to graphical UI and enable system services"
echo "========================================================================"

sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service
sudo systemctl enable cronie.service

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/core $HOME/core

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

cp -R $HOME/core/home/.??* $HOME/
cp -R $HOME/core/arch/home/.??* $HOME/
sudo cp -R $HOME/core/root/* /
sudo cp -R $HOME/core/arch/root/* /
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/{gtk-3.0,micro,qt5ct,qt6ct}
for dir in gtk-3.0 micro qt5ct qt6ct; do
    sudo ln -sf $HOME/.config/$dir/* /root/.config/$dir/
done
if [ ! -f "$HOME/.install-info" ]; then
    printf '%s\n' '# Set command prompt' 'PS1="\[\e[01;31m\]\u \w/#\[\e[m\] "' \
    | sudo tee -a /root/.bashrc > /dev/null
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

    read -p "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh $HOME/scripts/mod-dpi-scaling-wm.sh;
           sudo sed -i 's/^greeter-wrapper/#greeter-wrapper/' /etc/lightdm/lightdm.conf;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

pc_type="$(hostnamectl chassis)"
if [ $pc_type = laptop ] || [ $pc_type = notebook ] \
    || [ $pc_type = portable ]; then
    echo "========================================================================"
    echo "Modify window manager configs for laptop use"
    echo "========================================================================"

    sh $HOME/scripts/mod-wm-laptop.sh
elif [ $pc_type = vm ]; then
    echo "========================================================================"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "========================================================================"

    sh $HOME/scripts/mod-virt-machines.sh
fi

echo "========================================================================"
echo "Install custom themes and change Papirus folders color"
echo "========================================================================"

sh $HOME/scripts/install-custom-themes.sh
if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi
papirus-folders -C adwaita --theme Papirus-Dark

echo "========================================================================"
echo "Add bookmarks and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sed -i '/libexec/d' $HOME/.config/dk/dkrc
sed -i 's/#\/usr\/lib/\/usr\/lib/' $HOME/.config/dk/dkrc
sed -i 's/#xbindkeys/xbindkeys/' $HOME/.config/dk/dkrc
sed -i 's/brave-browser/brave/' $HOME/.config/dk/sxhkdrc
sed -i 's/"top": 1,/"top": 0,/' $HOME/.config/fastfetch/config.jsonc
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt5ct/qt5ct.conf
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt6ct/qt6ct.conf
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
printf "%s\n" "" "# Set XDG_CURRENT_DESKTOP" "export XDG_CURRENT_DESKTOP=dk" \
| tee -a $HOME/.profile > /dev/null
cp -R $HOME/scripts/set-theming-dk.sh $HOME/.local/bin/set-theming-dk
echo "dk installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a $HOME/.install-info > /dev/null
rm -rf $HOME/core
rm -rf $HOME/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
