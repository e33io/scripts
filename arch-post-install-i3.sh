#!/bin/bash

# =======================================================================
# Arch Linux (post-install) i3
# URL: https://github.com/e33io/scripts/blob/main/arch-post-install-i3.sh
# -----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Only use with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the i3 window manager and a base set of apps for a
# ready-to-use desktop session.
# -----------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors
# (192 dpi settings for 2x scaling) and desktop-type computers,
# but there are options at the end of the script that let you change
# to non-HiDPI monitors (96 dpi settings for 1x scaling),
# and/or change to laptop-type (battery powered) computer settings.
# -----------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -Syu
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-post-install-i3.sh
# =======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Install i3 and other packages"
echo "################################################################"

sudo pacman -S xorg-server xorg-apps i3-wm i3status i3lock python-i3ipc py3status xss-lock dmenu rofi dunst gvfs nfs-utils cifs-utils fuse rsync cronie git curl wget tar less 7zip base-devel xsel xclip playerctl dex polkit-gnome xdg-desktop-portal-gtk xdg-user-dirs xbindkeys xdotool lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lxappearance-gtk3 gnome-themes-extra gtk-engine-murrine qt5ct qt6ct ttf-dejavu noto-fonts-emoji papirus-icon-theme plymouth pavucontrol-qt nitrogen kitty python-pillowfight xterm thunar thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer engrampa scrot atril imv mpv parole mousepad galculator dconf-editor gnome-disk-utility timeshift vim nano micro fzf htop fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo perl-image-exiftool signal-desktop darktable gimp inkscape filezilla libreoffice

echo "################################################################"
echo "Setup Yay for AUR"
echo "################################################################"

git clone https://aur.archlinux.org/yay.git $HOME/yay
cd $HOME/yay
makepkg -si
cd

echo "################################################################"
echo "Install packages from AUR"
echo "################################################################"

yay -S adwaita-qt5-git
yay -S adwaita-qt6-git
yay -S mintstick
yay -S brave-bin
yay -S octopi

echo "################################################################"
echo "Enable LightDM"
echo "################################################################"

sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service

echo "################################################################"
echo "Clone custom configuration files"
echo "################################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "################################################################"
echo "Copy custom configuration files"
echo "################################################################"

mkdir -p $HOME/.local/bin
cp -R $HOME/dotfiles/.config $HOME
cp -R $HOME/dotfiles/.icons $HOME
cp -R $HOME/dotfiles/.local/bin $HOME/.local
cp -R $HOME/dotfiles/.gtkrc* $HOME
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/dotfiles/.Xresources $HOME
cp -R $HOME/opt-dots/arch/.config $HOME
cp -R $HOME/opt-dots/arch/.local $HOME
cp -R $HOME/opt-dots/arch/.bash_profile $HOME
cp -R $HOME/opt-dots/arch/.bashrc $HOME
cp -R $HOME/opt-dots/arch/.profile $HOME
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/dotfiles/usr/share/grub /usr/share
sudo cp -R $HOME/dotfiles/usr/share/gtksourceview-4 /usr/share
sudo cp -R $HOME/dotfiles/usr/share/pixmaps /usr/share
sudo cp -R $HOME/dotfiles/usr/share/wallpapers /usr/share
sudo cp -R $HOME/opt-dots/arch/etc/lightdm /etc
sudo mv /usr/share/wayland-sessions/weston.desktop /usr/share/wayland-sessions/weston.desktop.bak
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/qt5ct
sudo mkdir -p /root/.config/qt6ct
sudo ln -s $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
sudo ln -s $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
sudo ln -s $HOME/.config/qt6ct/qt6ct.conf /root/.config/qt6ct/qt6ct.conf
sudo ln -s $HOME/.gtkrc-2.0 /root/.gtkrc-2.0

echo "################################################################"
echo "Update root .bashrc file"
echo "################################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc > /dev/null

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
           sudo sed -i 's/^greeter-wrapper/#greeter-wrapper/' /etc/lightdm/lightdm.conf;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

clear
while true; do
    echo "################################################################"
    echo "The option below lets you select a configuration"
    echo "specific to your computer type."
    echo "################################################################"
    echo "   1) Desktop"
    echo "   2) Laptop"
    echo "----------------------------------------------------------------"

    read -p "What type of computer are you using? " n
    case $n in
        1) echo "You chose Desktop computer";
           break;;
        2) echo "You chose Laptop computer";
           sh mod-wm-laptop.sh;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "################################################################"
echo "Clean up user directory"
echo "################################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sed -i 's/brave-browser/brave/' $HOME/.config/i3/config
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt5ct/qt5ct.conf
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt6ct/qt6ct.conf
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
echo '# Set default volume level (using pactl)
exec --no-startup-id sleep 2 && pactl set-sink-volume @DEFAULT_SINK@ 25% && $refresh_i3status' \
| tee -a $HOME/.config/i3/config > /dev/null
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
