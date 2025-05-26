#!/bin/bash

# ============================================================================
# Fedora Workstation Setup (post-install)
# URL: https://github.com/e33io/scripts/blob/main/fed-workstation-setup.sh
# ----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with a fresh install of Fedora Workstation!
# ----------------------------------------------------------------------------
# Post-install instructions:
#   - open Software Center and enable third-party repos and run updates/reboot
#   - open Terminal and run this script:
#       - git clone https://github.com/e33io/scripts
#       - cd scripts
#       - sh fed-workstation-setup.sh
#       (the script will reboot the system when it's done)
# ============================================================================

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

flatpak install -y --noninteractive com.mattjakeman.ExtensionManager
flatpak install -y --noninteractive org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y --noninteractive org.signal.Signal

echo "################################################################"
echo "Add rpmfusion free and nonfree repositories"
echo "################################################################"

sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf -y install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "################################################################"
echo "Run system update"
echo "################################################################"

sudo dnf -y update

echo "################################################################"
echo "Install other packages"
echo "################################################################"

sudo dnf -y install gnome-tweaks dconf-editor gnome-shell-extension-appindicator adwaita-gtk* gnome-themes-extra papirus-icon-theme htop fastfetch cava cmus perl-Image-ExifTool decibels timeshift filezilla gimp darktable inkscape gcolor3

pc_type="$(hostnamectl chassis)"
if [ $pc_type = desktop ]; then
    sudo dnf -y install input-remapper
    sudo systemctl enable --now input-remapper
fi

echo "################################################################"
echo "Install Brave Browser"
echo "################################################################"

sudo dnf -y install dnf-plugins-core
sudo dnf -y config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf -y install brave-browser

echo "################################################################"
echo "Add and setup multimedia packages/codecs"
echo "################################################################"

sudo dnf -y swap ffmpeg-free ffmpeg --allowerasing
sudo dnf -y update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
sudo dnf -y install rpmfusion-free-release-tainted
sudo dnf -y install libdvdcss
sudo dnf -y install rpmfusion-nonfree-release-tainted
sudo dnf -y --repo=rpmfusion-nonfree-tainted install "*-firmware"

echo "################################################################"
echo "Clone custom configuration files"
echo "################################################################"

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/opt-dots $HOME/opt-dots

echo "################################################################"
echo "Copy custom configuration files"
echo "################################################################"

cp -R $HOME/opt-dots/fedora-gnome/.config $HOME
cp -R $HOME/opt-dots/fedora-gnome/.local $HOME
cp -R $HOME/opt-dots/fedora-gnome/.bashrc $HOME
sudo cp -R $HOME/dotfiles/usr/share/fonts /usr/share
sudo cp -R $HOME/opt-dots/fedora-gnome/usr/share/gtksourceview-4 /usr/share
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
sh gnome-dconf-setup.sh
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts
reboot
