#!/bin/bash

# ==========================================================================
# Arch Gnome Setup (post-install)
# URL: https://github.com/e33io/scripts/blob/main/arch-gnome-post-install.sh
# --------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with a fresh archinstall of Arch Gnome!
# --------------------------------------------------------------------------
# Post-install instructions:
#   - open Terminal and run these commands:
#       - sudo pacman -Syu
#       - sudo pacman -S git
#       - git clone https://github.com/e33io/scripts
#       - cd scripts
#       - sh arch-gnome-post-install.sh
#       (the script will reboot the system when it's done)
# ==========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Install flatpak packages"
echo "################################################################"

sudo -k
flatpak install -y --noninteractive com.mattjakeman.ExtensionManager
flatpak install -y --noninteractive org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y --noninteractive org.torproject.torbrowser-launcher

echo "################################################################"
echo "Remove unneeded/unwanted packages"
echo "################################################################"

sudo pacman -R gnome-software

echo "################################################################"
echo "Install other packages"
echo "################################################################"

sudo pacman -S ptyxis gnome-shell-extension-appindicator dconf-editor gnome-themes-extra papirus-icon-theme nfs-utils less micro fzf fastfetch cava cmus perl-image-exiftool timeshift signal-desktop filezilla gimp darktable inkscape gcolor3 libreoffice

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

yay -S mintstick
yay -S brave-bin
yay -S octopi

pc_type="$(hostnamectl chassis)"
if [ $pc_type = desktop ]; then
    yay -S input-remapper
    sudo systemctl enable --now input-remapper
fi

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
cp -R $HOME/opt-dots/arch-gnome/.config $HOME
cp -R $HOME/opt-dots/arch-gnome/.local $HOME
cp -R $HOME/opt-dots/arch-gnome/.bash_profile $HOME
cp -R $HOME/opt-dots/arch-gnome/.bashrc $HOME
cp -R $HOME/opt-dots/arch-gnome/.profile $HOME
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/opt-dots/arch-gnome/usr/share/gtksourceview-4 /usr/share
sudo cp -R /usr/share/gtksourceview-4/* /usr/share/gtksourceview-5
fc-cache -f

echo "################################################################"
echo "Update root .bashrc file"
echo "################################################################"

echo "#
# Set command prompt
PS1='\[\e[01;31m\][\u \w]#\[\e[m\] '
#" | sudo tee -a /root/.bashrc > /dev/null

echo "################################################################"
echo "Add bookmarks, run dconf script, clean up files and reboot"
echo "################################################################"

echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music
file:/// /" > $HOME/.config/gtk-3.0/bookmarks
sh $HOME/scripts/gnome-dconf-setup.sh
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts
reboot
