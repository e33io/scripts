#!/bin/bash

# =============================================================================
# Arch Linux - Install Xfce
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

sudo pacman -S --noconfirm --needed xfce4 xfce4-screensaver xfce4-screenshooter xfce4-taskmanager xfce4-notifyd \
xfce4-battery-plugin xfce4-pulseaudio-plugin xfce4-docklike-plugin xfce4-windowck-plugin thunar-archive-plugin \
network-manager-applet gvfs nfs-utils cifs-utils rsync cronie git curl wget tar 7zip less base-devel \
ffmpegthumbnailer xsel xclip xdg-desktop-portal-gtk xdg-user-dirs xiccd xorg-apps wmctrl xdotool xbindkeys plymouth \
lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings gnome-themes-extra gtk-engine-murrine qt5ct qt6ct ttf-dejavu \
noto-fonts-emoji papirus-icon-theme breeze-icons pavucontrol engrampa atril ristretto imv mpv parole rhythmbox \
mousepad galculator dconf-editor gnome-disk-utility timeshift xterm bash-completion vim nano micro fzf lazygit htop \
fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo perl-image-exiftool signal-desktop gpick darktable \
gimp inkscape filezilla libreoffice

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
echo "Install packages from AUR"
echo "========================================================================"

yay -S --noconfirm --needed --sudoloop menulibre adwaita-qt5 adwaita-qt6 mintstick brave-bin

echo "========================================================================"
echo "Enable LightDM"
echo "========================================================================"

sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/extra $HOME/extra

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

mkdir -p $HOME/.config/micro
mkdir -p $HOME/.local/bin
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/extra/xfce/.config $HOME
cp -R $HOME/extra/arch-xfce/.config $HOME
cp -R $HOME/extra/arch-xfce/.local $HOME
cp -R $HOME/extra/arch-xfce/.bash_profile $HOME
cp -R $HOME/extra/arch-xfce/.bashrc $HOME
cp -R $HOME/extra/arch-xfce/.profile $HOME
cp -R $HOME/extra/xfce/.Xresources $HOME
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/dotfiles/usr/share/grub /usr/share
sudo cp -R $HOME/dotfiles/usr/share/gtksourceview-4 /usr/share
sudo cp -R $HOME/dotfiles/usr/share/pixmaps /usr/share
sudo cp -R $HOME/dotfiles/usr/share/wallpapers /usr/share
sudo cp -R $HOME/extra/arch-xfce/etc/lightdm /etc
sudo cp -R $HOME/extra/xfce/usr/bin /usr
sudo cp -R $HOME/extra/xfce/usr/share /usr
sudo cp -R $HOME/scripts/window-control.sh /usr/bin
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/micro
sudo mkdir -p /root/.config/qt5ct
sudo mkdir -p /root/.config/qt6ct
sudo ln -sf $HOME/.config/micro/* /root/.config/micro
sudo ln -sf $HOME/.config/qt5ct/* /root/.config/qt5ct
sudo ln -sf $HOME/.config/qt6ct/* /root/.config/qt6ct
sudo mv /usr/share/backgrounds/xfce/xfce-x.svg /usr/share/backgrounds/xfce/xfce-default.svg
sudo ln -sf /usr/share/wallpapers/background-2.png /usr/share/backgrounds/xfce/xfce-x.svg

if [ ! -f "$HOME/.install-info" ]; then
    echo "========================================================================"
    echo "Update root .bashrc file"
    echo "========================================================================"

    printf '%s\n' '' '# Set command prompt' 'PS1="\[\e[01;31m\]\u \w/#\[\e[m\] "' \
    | sudo tee -a /root/.bashrc > /dev/null
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

    read -p "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh $HOME/scripts/mod-dpi-scaling-xfce.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

pc_type="$(hostnamectl chassis)"
if [ $pc_type = vm ]; then
    echo "========================================================================"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "========================================================================"

    sh $HOME/scripts/mod-virt-machines.sh
fi

echo "========================================================================"
echo "Change Papirus folders color"
echo "========================================================================"

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
sed -i "s/home\/.*\/\.local/home\/$(whoami)\/\.local/" $HOME/.config/menus/xfce-applications.menu
sed -i 's/"top": 1,/"top": 0,/' $HOME/.config/fastfetch/config.jsonc
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt5ct/qt5ct.conf
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt6ct/qt6ct.conf
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
cp -R $HOME/scripts/set-theming-xfce.sh $HOME/.local/bin/set-theming-xfce
echo "Xfce installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a $HOME/.install-info > /dev/null
rm -rf $HOME/dotfiles
rm -rf $HOME/extra
rm -rf $HOME/scripts

echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
