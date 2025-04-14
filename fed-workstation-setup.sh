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

sudo dnf -y install gnome-tweaks adwaita-gtk* gnome-themes-extra dconf-editor htop fastfetch papirus-icon-theme timeshift filezilla gimp darktable inkscape

flatpak install -y --noninteractive com.mattjakeman.ExtensionManager
flatpak install -y --noninteractive org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y --noninteractive org.signal.Signal
flatpak install -y --noninteractive org.torproject.torbrowser-launcher
flatpak install -y --noninteractive nl.hjdskes.gcolor3

curl -fsSL https://repo.librewolf.net/librewolf.repo | pkexec tee /etc/yum.repos.d/librewolf.repo
sudo dnf -y install librewolf

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
echo "Run dconf setup script, clean up files and reboot"
echo "################################################################"

sh fed-dconf-setup.sh
sudo rm -R $HOME/dotfiles
sudo rm -R $HOME/opt-dots
sudo rm -R $HOME/scripts
reboot
