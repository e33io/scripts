#!/bin/bash

# ================================================================================
# openSUSE (post-install) i3 Installation
# URL: https://github.com/e33io/scripts/blob/main/opensuse-post-install-i3.sh
# --------------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with an openSUSE Tumbleweed "Generic Desktop" installation to install the
# i3 window manager and a base set of apps for a ready-to-use desktop session.
# --------------------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors (192 dpi settings)
# and desktop-type computers, but there are options at the end of the script
# that let you change to 96 dpi settings for use with non-HiDPI monitors,
# and/or change to laptop-type (battery powered) computer settings.
# --------------------------------------------------------------------------------
# NOTE: When installing openSUSE Tumbleweed, within the Generic Desktop selection,
#       uncheck `patterns-base-x11_enhanced` in the X Window System section of
#       the installer (to keep the initial install more minimal), then go to the
#       Search tab in the installer and select `sudo` and `git` to be installed
#
#       When running the script, enter your password and answer yes (y) or
#       trust always (a) to all prompts
#
#       When the script is done, enter `sudo reboot`, then login to i3 session
# --------------------------------------------------------------------------------
# Instructions for running this script:
#   sudo zypper install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh opensuse-post-install-i3.sh
# ================================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

echo "#########################################################"
echo "Add X11:Utilities repository"
echo "#########################################################"

sudo zypper ar -f https://download.opensuse.org/repositories/X11:Utilities/openSUSE_Tumbleweed/X11:Utilities.repo
sudo zypper refresh

echo "#########################################################"
echo "Run system update"
echo "#########################################################"

sudo zypper dup --no-recommends

echo "#########################################################"
echo "Install i3 and other packages"
echo "#########################################################"

sudo zypper install i3 python312-i3ipc python312-py3status xss-lock xautolock rofi dunst xsel xclip xinput xbindkeys xdotool playerctl xdg-user-dirs xdg-utils xf86-video-amdgpu gvfs-fuse gvfs-backends nfs-client exfatprogs polkit-gnome dex git wget rsync cronie fuse psmisc words opi lxappearance qt5ct adwaita-qt5 gnome-themes-extras papirus-icon-theme google-noto-coloremoji-fonts nitrogen yast2-control-center-qt thunar thunar-plugin-archive tumbler ffmpegthumbnailer engrampa kitty pipewire-pulseaudio pavucontrol gnome-disk-utility atril imv mpv parole mousepad galculator xfce4-screenshooter flameshot NetworkManager-tui htop neofetch ranger nano micro-editor fzf exiftool cmus cava darktable gimp inkscape filezilla libreoffice libreoffice-gtk3

echo "#########################################################"
echo "Install LibreWolf Web Browser"
echo "#########################################################"

sudo rpm --import https://rpm.librewolf.net/pubkey.gpg
sudo zypper ar -ef https://rpm.librewolf.net librewolf
sudo zypper refresh
sudo zypper install librewolf

echo "#########################################################"
echo "Remove unneeded/unwanted packages"
echo "#########################################################"

sudo zypper remove icewm* openbox *obconf* libobrender32 libobt2 xscreensaver*

echo "#########################################################"
echo "Clone custom configuration files"
echo "#########################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "#########################################################"
echo "Copy custom configuration files"
echo "#########################################################"

mkdir -p $HOME/.local/bin
cp -R $HOME/dotfiles/.config $HOME
cp -R $HOME/dotfiles/.icons $HOME
cp -R $HOME/dotfiles/.local/bin $HOME/.local
cp -R $HOME/dotfiles/.gtkrc* $HOME
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/dotfiles/.Xresources $HOME
cp -R $HOME/opt-dots/opensuse/.config $HOME
cp -R $HOME/opt-dots/opensuse/.local $HOME
cp -R $HOME/opt-dots/opensuse/.bashrc $HOME
cp -R $HOME/opt-dots/opensuse/.profile $HOME
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/dotfiles/usr/share/grub/* /usr/share/grub2
sudo cp -R $HOME/dotfiles/usr/share/gtksourceview-4 /usr/share
sudo cp -R $HOME/dotfiles/usr/share/pixmaps /usr/share
sudo cp -R $HOME/dotfiles/usr/share/wallpapers /usr/share
sudo cp -R $HOME/opt-dots/opensuse/etc/default/grub /etc/default
sudo mkdir -p /boot/grub2/fonts
sudo cp /usr/share/grub2/ter-* /boot/grub2/fonts
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/qt5ct
sudo ln -s $HOME/.config/gtk-3.0/settings.ini /root/.config/gtk-3.0/settings.ini
sudo ln -s $HOME/.config/qt5ct/qt5ct.conf /root/.config/qt5ct/qt5ct.conf
sudo ln -s $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
sudo ln -s /usr/sbin/mkfs.exfat /usr/local/sbin/mkexfatfs
sudo chmod u+s /bin/mount
sudo chmod u+s /bin/umount
sudo chmod u+s /sbin/mount.cifs
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

echo "#########################################################"
echo "Update i3 config file"
echo "#########################################################"

echo '# openSUSE specific options
for_window [class="Catfish"] floating enable, resize set 1440 1280, move position center
for_window [class="imagewriter"] floating enable, move position center
for_window [class=".*YaST.*"] floating enable, resize set 3000 2000, move position center
for_window [title="xdg-su: .*"] floating enable' | tee -a $HOME/.config/i3/config > /dev/null

echo "#########################################################"
echo "Update root .bashrc file"
echo "#########################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc > /dev/null

echo "#########################################################"
echo "NOTE: The configs that were installed with this script"
echo "are based on using HiDPI monitors (192 dpi settings)."
echo "The option below lets you change to 96 dpi settings for"
echo "use with non-HiDPI monitors."
echo "---------------------------------------------------------"

while true; do
    read -p "Do you want to change to 96 dpi non-HiDPI settings? (y/n) " yn
    case $yn in
        [Yy]* ) sh mod-dpi-scaling-wm.sh;
                echo "You chose to change to non-HiDPI settings";
                break;;
        [Nn]* ) echo "You chose to keep the default HiDPI settings";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

echo "#########################################################"
echo "NOTE: The configs that were installed with this script"
echo "are based on using a desktop-type computer."
echo "The option below lets you change to laptop configs for"
echo "use with a laptop-type (battery powered) computer."
echo "---------------------------------------------------------"

while true; do
    read -p "Do you want to change to laptop configs? (y/n) " yn
    case $yn in
        [Yy]* ) sh mod-wm-laptop.sh;
                echo "You chose to change to laptop configs";
                break;;
        [Nn]* ) echo "You chose to keep the default desktop configs";
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
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
rm -R $HOME/.config/autostart/polkit-gnome-authentication-agent-1.desktop
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts

echo "#########################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "#########################################################"
