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
# (192 dpi settings for 2x scaling), but there is an option
# at the end of the script that lets you change to standard
# HD monitors (96 dpi settings for 1x scaling).
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

sudo pacman -S --noconfirm --needed xorg-server xorg-apps i3-wm i3status i3lock python-i3ipc py3status xss-lock dmenu rofi dunst gvfs \
nfs-utils cifs-utils fuse rsync cronie git curl wget tar less 7zip base-devel xsel xclip playerctl dex mate-polkit xdg-desktop-portal-gtk \
xdg-user-dirs xbindkeys xdotool lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lxappearance-gtk3 gnome-themes-extra \
gtk-engine-murrine qt5ct qt6ct ttf-dejavu noto-fonts-emoji papirus-icon-theme breeze-icons plymouth pavucontrol-qt nitrogen kitty \
python-pillowfight xterm thunar thunar-archive-plugin thunar-volman tumbler ffmpegthumbnailer engrampa scrot atril imv mpv parole mousepad \
galculator dconf-editor gnome-disk-utility timeshift bash-completion vim nano micro fzf lazygit htop fastfetch cmus cava ranger ueberzug \
highlight atool w3m mediainfo perl-image-exiftool signal-desktop darktable gimp inkscape filezilla libreoffice

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

yay -S --noconfirm --needed --sudoloop xssproxy adwaita-qt5-git adwaita-qt6-git mintstick brave-bin octopi

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
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mv /usr/share/wayland-sessions/weston.desktop /usr/share/wayland-sessions/weston.desktop.bak
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/micro
sudo mkdir -p /root/.config/qt5ct
sudo mkdir -p /root/.config/qt6ct
sudo ln -sf $HOME/.config/gtk-3.0/* /root/.config/gtk-3.0
sudo ln -sf $HOME/.config/micro/* /root/.config/micro
sudo ln -sf $HOME/.config/qt5ct/* /root/.config/qt5ct
sudo ln -sf $HOME/.config/qt6ct/* /root/.config/qt6ct
sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0

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

pc_type="$(hostnamectl chassis)"
if [ $pc_type = laptop ]; then
    echo "################################################################"
    echo "Modify window manager configs for laptop use"
    echo "################################################################"

    sh mod-wm-laptop.sh
fi
if [ $pc_type = vm ]; then
    echo "################################################################"
    echo "Install spice-vdagent and update lightdm scaling"
    echo "################################################################"

    sudo pacman -S --noconfirm --needed spice-vdagent
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

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
rm -rf $HOME/dotfiles
rm -rf $HOME/opt-dots
rm -rf $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
