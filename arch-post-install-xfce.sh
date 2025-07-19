#!/bin/bash

# =========================================================================
# Arch Linux (post-install) Xfce
# URL: https://github.com/e33io/scripts/blob/main/arch-post-install-xfce.sh
# -------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Only use with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the Xfce desktop environment and a base set of apps for a
# ready-to-use desktop session.
# -------------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -Syu
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-post-install-xfce.sh
# =========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Install Xfce and other packages"
echo "################################################################"

sudo pacman -S --noconfirm --needed xfce4 xfce4-screensaver xfce4-screenshooter xfce4-taskmanager xfce4-notifyd \
xfce4-battery-plugin xfce4-pulseaudio-plugin xfce4-docklike-plugin xfce4-windowck-plugin thunar-archive-plugin \
network-manager-applet gvfs nfs-utils cifs-utils fuse rsync cronie git curl wget tar 7zip less base-devel \
ffmpegthumbnailer xsel xclip xdg-desktop-portal-gtk xdg-user-dirs xiccd xorg-apps wmctrl xdotool xbindkeys plymouth \
lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings gnome-themes-extra gtk-engine-murrine qt5ct qt6ct ttf-dejavu \
noto-fonts-emoji papirus-icon-theme breeze-icons pavucontrol engrampa atril ristretto imv mpv parole rhythmbox \
mousepad galculator dconf-editor gnome-disk-utility timeshift xterm bash-completion vim nano micro fzf lazygit htop \
fastfetch cmus cava ranger ueberzug highlight atool w3m mediainfo perl-image-exiftool signal-desktop gpick darktable \
gimp inkscape filezilla libreoffice

echo "################################################################"
echo "Setup Yay for AUR"
echo "################################################################"

git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
cd $HOME/yay-bin
makepkg -si --noconfirm
cd
rm -rf $HOME/yay-bin

echo "################################################################"
echo "Install packages from AUR"
echo "################################################################"

yay -S --noconfirm --needed --sudoloop menulibre adwaita-qt5-git adwaita-qt6-git mintstick brave-bin octopi

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

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/opt-dots/xfce/.config $HOME
cp -R $HOME/opt-dots/arch-xfce/.config $HOME
cp -R $HOME/opt-dots/arch-xfce/.local $HOME
cp -R $HOME/opt-dots/arch-xfce/.bash_profile $HOME
cp -R $HOME/opt-dots/arch-xfce/.bashrc $HOME
cp -R $HOME/opt-dots/arch-xfce/.profile $HOME
cp -R $HOME/opt-dots/xfce/.Xresources $HOME
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/dotfiles/usr/share/grub /usr/share
sudo cp -R $HOME/dotfiles/usr/share/gtksourceview-4 /usr/share
sudo cp -R $HOME/dotfiles/usr/share/pixmaps /usr/share
sudo cp -R $HOME/dotfiles/usr/share/wallpapers /usr/share
sudo cp -R $HOME/opt-dots/arch-xfce/etc/lightdm /etc
sudo cp -R $HOME/opt-dots/xfce/usr/bin /usr
sudo cp -R $HOME/opt-dots/xfce/usr/share /usr
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
sudo ln -sf /usr/share/wallpapers/background.png /usr/share/backgrounds/xfce/xfce-x.svg

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
    echo "   1) Standard HD (96 dpi settings for 'Window Scaling 1x')"
    echo "   2) HiDPI (192 dpi settings for 'Window Scaling 2x')"
    echo "----------------------------------------------------------------"

    read -p "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh mod-dpi-scaling-xfce.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

pc_type="$(hostnamectl chassis)"
if [ $pc_type = vm ]; then
    echo "################################################################"
    echo "Install spice-vdagent and update lightdm scaling"
    echo "################################################################"

    sudo pacman -S --noconfirm --needed spice-vdagent
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

echo "################################################################"
echo "Add bookmarks and clean up user directory"
echo "################################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sed -i "s/home\/.*\/\.local/home\/$(whoami)\/\.local/" $HOME/.config/menus/xfce-applications.menu
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt5ct/qt5ct.conf
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt6ct/qt6ct.conf
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
printf "%s\n" "[Desktop Entry]" "Type=Application" "Name=audio-default" \
"Comment=set default volume level" "Icon=xfce4-mixer" \
"Exec=sh -c 'sleep 2; pactl set-sink-volume @DEFAULT_SINK@ 25%%'" \
"NoDisplay=true" "Hidden=false" > $HOME/.config/autostart/audio-default.desktop
chmod +x $HOME/.config/autostart/audio-default.desktop
rm -rf $HOME/dotfiles
rm -rf $HOME/opt-dots
rm -rf $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
