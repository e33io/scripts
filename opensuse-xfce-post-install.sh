#!/bin/bash

# =============================================================================
# openSUSE Xfce (post-install) Package Installation and Custom Configuration
# URL: https://github.com/e33io/scripts/blob/main/opensuse-xfce-post-install.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with an openSUSE Tumbleweed "Desktop with Xfce" installation to install
# additional packages and setup custom configuration files.
# -----------------------------------------------------------------------------
# Configs and theming are based on using HiDPI monitors (Window Scaling 2x),
# but there is an option at the end of the script that lets you change to
# 'Window Scaling 1x' settings for use with non-HiDPI monitors.
# -----------------------------------------------------------------------------
# NOTE: When running the script, enter your password and answer yes (y) or
#       trust always (a) to all prompts
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Run system update"
echo "#########################################################"

sudo zypper dup --no-recommends

echo "#########################################################"
echo "Remove unneeded/unwanted packages"
echo "#########################################################"

sudo zypper remove icewm* file-roller evince*

echo "#########################################################"
echo "Install other packages"
echo "#########################################################"

sudo zypper install xsel xinput xbindkeys xdotool xdpyinfo playerctl xf86-video-amdgpu exfatprogs git opi qt5ct adwaita-qt5 gnome-themes-extras papirus-icon-theme words htop neofetch ranger micro-editor fzf cmus cava engrampa atril flameshot darktable gimp inkscape libreoffice libreoffice-gtk3

echo "#########################################################"
echo "Clone custom configuration files"
echo "#########################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "#########################################################"
echo "Copy custom configuration files"
echo "#########################################################"

mkdir -p $HOME/.config/micro
cp -R $HOME/dotfiles/.config/micro $HOME/.config
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/opt-dots/xfce/.Xresources $HOME
cp -R $HOME/opt-dots/opensuse-xfce/.config $HOME
cp -R $HOME/opt-dots/opensuse-xfce/.local $HOME
cp -R $HOME/opt-dots/opensuse-xfce/.bashrc $HOME
cp -R $HOME/opt-dots/opensuse-xfce/.profile $HOME
if [ -d "/usr/share/slick-greeter" ]; then
    sudo cp -R $HOME/dotfiles/etc/lightdm /etc
fi
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/dotfiles/usr/share/grub/* /usr/share/grub2
sudo cp -R $HOME/dotfiles/usr/share/gtksourceview-4 /usr/share
sudo cp -R $HOME/dotfiles/usr/share/pixmaps /usr/share
sudo cp -R $HOME/dotfiles/usr/share/wallpapers /usr/share
sudo cp -R $HOME/opt-dots/xfce/usr/bin /usr
sudo cp -R $HOME/opt-dots/xfce/usr/share /usr
sudo cp -R $HOME/opt-dots/opensuse/etc/default/grub /etc/default
sudo mkdir -p /boot/grub2/fonts
sudo cp /usr/share/grub2/ter-* /boot/grub2/fonts
sudo mkdir -p /root/.config/qt5ct
sudo ln -s $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
sudo ln -s /usr/sbin/mkfs.exfat /usr/local/sbin/mkexfatfs
sudo chmod u+s /bin/mount
sudo chmod u+s /bin/umount
sudo chmod u+s /sbin/mount.cifs
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "#########################################################"
echo "Update root .bashrc file"
echo "#########################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc > /dev/null

echo "#########################################################"
echo "NOTE: The configs that were installed with this script"
echo "are based on using HiDPI monitors (Window Scaling 2x)."
echo "The option below lets you change to 'Window Scaling 1x'"
echo "settings for use with non-HiDPI monitors."
echo "---------------------------------------------------------"

while true; do
    read -p "Do you want to change to 'Window Scaling 1x' non-HiDPI settings? (y/n) " yn
    case $yn in
        [Yy]* ) sh mod-dpi-scaling-xfce.sh
                echo "You chose to change to non-HiDPI settings";
                break;;
        [Nn]* ) echo "You chose to keep the default HiDPI settings";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "#########################################################"
echo "Clean up user directory"
echo "#########################################################"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
