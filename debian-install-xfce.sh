#!/bin/bash

# =============================================================================
# Debian Linux - Install Xfce (desktop environment)
# URL: https://github.com/e33io/scripts/blob/main/debian-install-xfce.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the Xfce desktop
# environment and a base set of apps for a ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh debian-install-xfce.sh
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
echo "Update and upgrade system"
echo "========================================================================"

sudo apt update
sudo apt -y upgrade

echo "========================================================================"
echo "Install Xfce and other packages"
echo "========================================================================"

sudo apt -y install xfce4 xfce4-terminal xfce4-power-manager xfce4-screensaver xfce4-screenshooter \
xfce4-taskmanager xfce4-docklike-plugin xfce4-windowck-plugin thunar-archive-plugin xarchiver tumbler-plugins-extra \
network-manager-gnome mate-polkit lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings wmctrl xdotool \
xbindkeys xclip gvfs-fuse gvfs-backends nfs-common cifs-utils pipewire-audio apt-transport-https curl rsync \
gnome-themes-extra qt*ct adwaita-qt* papirus-icon-theme breeze-icon-theme fonts-noto-color-emoji plymouth \
plymouth-themes xterm micro imv mpv lazygit fastfetch htop cmus cava cmatrix ncal ranger ueberzug caca-utils \
highlight atool w3m poppler-utils mediainfo fzf heif-thumbnailer heif-gdk-pixbuf libimage-exiftool-perl \
mousepad menulibre atril ristretto parole rhythmbox galculator gnome-disk-utility timeshift mintstick synaptic \
dconf-editor dconf-cli gpick darktable gimp inkscape filezilla libreoffice-calc libreoffice-draw \
libreoffice-impress libreoffice-writer libreoffice-gtk3

if ! command -v brave-browser > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Install Brave Browser"
    echo "========================================================================"

    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
    https://brave-browser-apt-release.s3.brave.com/ stable main" \
    | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt -y install brave-browser
fi

if ! command -v signal-desktop > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Install Signal App"
    echo "========================================================================"

    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc \
    | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] \
    https://updates.signal.org/desktop/apt xenial main" \
    | sudo tee /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update
    sudo apt -y install signal-desktop
fi

echo "========================================================================"
echo "Clone custom configuration files"
echo "========================================================================"

git clone https://github.com/e33io/core ~/core
git clone https://github.com/e33io/extra ~/extra

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

mkdir -p ~/.local/bin
cp -R ~/extra/xfce/home/.??* ~/
cp -R ~/extra/xfce/debian/home/.??* ~/
cp -R ~/scripts/set-theming-xfce.sh ~/.local/bin/set-theming-xfce
sudo cp -R ~/core/root/* /
sudo cp -R ~/core/debian/root/* /
sudo cp -R ~/extra/xfce/root/* /
sudo cp -R ~/extra/xfce/debian/root/* /
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo rm -rf /usr/share/xsessions/lightdm-xsession.desktop
bash -c 'sudo mkdir -p /root/.config/{micro,qt5ct,qt6ct}'
for dir in micro qt5ct qt6ct; do
    sudo ln -sf ~/.config/$dir/* /root/.config/$dir/
done
sudo mv /usr/share/backgrounds/xfce/xfce-x.svg /usr/share/backgrounds/xfce/xfce-default.svg
sudo ln -sf /usr/share/wallpapers/background-0.png /usr/share/backgrounds/xfce/xfce-x.svg
sudo update-initramfs -u
sudo update-grub

echo "========================================================================"
echo "Install custom themes and change Papirus folders color"
echo "========================================================================"

sh ~/scripts/install-custom-themes.sh
if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
    papirus-folders -C adwaita --theme Papirus-Dark
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

    read -rp "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh ~/scripts/mod-dpi-scaling-xfce.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

if command -v hostnamectl > /dev/null 2>&1; then
    pc_type="$(hostnamectl chassis)"
    if [ "$pc_type" = vm ]; then
        echo "========================================================================"
        echo "Install spice-vdagent and update VM-specific configs"
        echo "========================================================================"

        sh ~/scripts/mod-virt-machines.sh
    fi
fi

echo "========================================================================"
echo "Update x-www-browser settings"
echo "========================================================================"

sudo update-alternatives --set x-www-browser /usr/bin/brave-browser-stable

if [ -f /etc/devuan_version ]; then
    echo "========================================================================"
    echo "Modify Debian configs for use with Devuan Linux"
    echo "========================================================================"

    sh ~/scripts/mod-debian-to-devuan.sh
fi

echo "========================================================================"
echo "Update and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
sed -i "s/\/user\//\/$(whoami)\//" ~/.config/gtk-3.0/bookmarks
sed -i -e 's/scheme_path=.*/scheme_path=\/usr\/share\/qt5ct\/colors\/airy\.conf/' \
-e 's/custom_palette=.*/custom_palette=false/' ~/.config/qt5ct/qt5ct.conf
sed -i -e 's/scheme_path=.*/scheme_path=\/usr\/share\/qt6ct\/colors\/airy\.conf/' \
-e 's/custom_palette=.*/custom_palette=false/' ~/.config/qt6ct/qt6ct.conf
sed -i 's/has imv, .* X, flag f = imv/X, flag f = \/usr\/libexec\/imv\/imv/' \
~/.config/ranger/rifle.conf
echo "Xfce installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/core
rm -rf ~/extra
rm -rf ~/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
