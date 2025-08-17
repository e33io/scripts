#!/bin/bash

# ==========================================================================
# Arch Linux (post-install) Gnome
# URL: https://github.com/e33io/scripts/blob/main/arch-post-install-gnome.sh
# --------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Only use with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to install the Gnome desktop environment and a base set of apps for a
# ready-to-use desktop session.
# --------------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -Syu
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-post-install-gnome.sh
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
echo "Install Gnome and other packages"
echo "################################################################"

sudo pacman -S --noconfirm --needed gnome gnome-tweaks gnome-shell-extension-appindicator file-roller ptyxis \
gnome-themes-extra papirus-icon-theme qt5ct qt6ct dconf-editor signal-desktop gimp darktable inkscape gcolor3 \
filezilla libreoffice timeshift nfs-utils bash-completion perl-image-exiftool vim nano micro fzf lazygit \
htop fastfetch cmus cava less wget
sudo pacman -R --noconfirm gnome-software gnome-console

echo "################################################################"
echo "Install flatpak packages"
echo "################################################################"

sudo -k
flatpak install -y --noninteractive com.mattjakeman.ExtensionManager
flatpak install -y --noninteractive org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y --noninteractive org.torproject.torbrowser-launcher

if ! command -v yay > /dev/null 2>&1; then
    echo "################################################################"
    echo "Setup Yay for AUR"
    echo "################################################################"

    git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
    cd $HOME/yay-bin
    makepkg -si --noconfirm
    cd
    rm -rf $HOME/yay-bin
fi

echo "################################################################"
echo "Install packages from AUR"
echo "################################################################"

yay -S --noconfirm --needed --sudoloop adwaita-qt5-git adwaita-qt6-git mintstick brave-bin octopi

pc_type="$(hostnamectl chassis)"
if [ $pc_type = desktop ]; then
    yay -S --noconfirm --needed --sudoloop input-remapper
    sudo systemctl enable --now input-remapper
fi
if [ $pc_type = vm ]; then
    echo "################################################################"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "################################################################"

    sh $HOME/scripts/mod-virt-machines.sh
fi

echo "################################################################"
echo "Enable GDM"
echo "################################################################"

sudo systemctl set-default graphical.target
sudo systemctl enable gdm.service

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
sudo cp -R $HOME/dotfiles/usr/share/grub /usr/share
sudo cp -R $HOME/opt-dots/arch-gnome/usr/share/gtksourceview-4 /usr/share
sudo cp -R /usr/share/gtksourceview-4/* /usr/share/gtksourceview-5
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
fc-cache -f

echo "################################################################"
echo "Update root .bashrc file"
echo "################################################################"

echo '#
# Set command prompt
PS1="\[\e[01;31m\]\u \w/#\[\e[m\] "
#' | sudo tee -a /root/.bashrc > /dev/null

echo "################################################################"
echo "Add bookmarks, run dconf script and clean up files"
echo "################################################################"

echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music
file:/// /" > $HOME/.config/gtk-3.0/bookmarks
sed -i 's/"top": 1,/"top": 0,/' $HOME/.config/fastfetch/config.jsonc
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt5ct/qt5ct.conf
sed -i "s/home\/.*\/\.config/home\/$(whoami)\/\.config/" $HOME/.config/qt6ct/qt6ct.conf
sh $HOME/scripts/gnome-dconf-setup.sh
sudo wget -q https://i.e33.io/wp/rancho-twilight-4k.jpg -P /usr/share/backgrounds
dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/rancho-twilight-4k.jpg'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/rancho-twilight-4k.jpg'"
dconf write /org/gnome/desktop/screensaver/picture-uri "'file:///usr/share/backgrounds/rancho-twilight-4k.jpg'"
echo "Gnome was installed via e33io script: $(date '+%B %d, %Y, %H:%M')" > $HOME/.install-info
rm -rf $HOME/dotfiles
rm -rf $HOME/opt-dots
rm -rf $HOME/scripts

echo "################################################################"
echo "All done, you can now run other commands or reboot the PC"
echo "################################################################"
