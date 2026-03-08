#!/bin/bash

# =============================================================================
# Install i3 (tiling window manager) on Debian Linux
# URL: https://github.com/e33io/scripts/blob/main/debian-install-i3.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the i3 window
# manager and a base set of apps for a ready-to-use desktop session.
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh debian-install-i3.sh
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
echo "Install i3 and other packages"
echo "========================================================================"

sudo apt -y install i3 polybar rofi network-manager xdotool xbindkeys xssproxy xsel xclip \
xinput x11-utils upower gvfs-fuse gvfs-backends nfs-common cifs-utils playerctl feh lxappearance \
qt*ct adwaita-qt* gnome-themes-extra papirus-icon-theme breeze-icon-theme fonts-dejavu \
fonts-noto-core fonts-noto-cjk fonts-noto-color-emoji mate-polkit-bin lightdm lightdm-gtk-greeter \
lightdm-gtk-greeter-settings plymouth plymouth-themes kitty python3-pypillowfight xterm lazygit \
fastfetch htop cmus cava cmatrix ncal micro ranger ueberzug caca-utils highlight atool w3m \
poppler-utils mediainfo fzf libimage-exiftool-perl apt-transport-https curl rsync dconf-cli \
thunar thunar-archive-plugin tumbler-plugins-extra ffmpegthumbnailer heif-thumbnailer \
heif-gdk-pixbuf xarchiver pipewire-audio pulseaudio-utils pavucontrol-qt synaptic timeshift \
mintstick scrot atril imv mpv parole mousepad galculator filezilla gpick darktable gimp inkscape \
libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3

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

git clone https://github.com/e33io/dots ~/dots

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

cp -R ~/dots/home/.??* ~/
cp -R ~/dots/debian/home/.??* ~/
sudo cp -R ~/dots/root/* /
sudo cp -R ~/dots/debian/root/* /
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo rm -rf /usr/share/xsessions/lightdm-xsession.desktop
bash -c 'sudo mkdir -p /root/.config/{gtk-3.0,micro,qt5ct,qt6ct}'
for dir in gtk-3.0 micro qt5ct qt6ct; do
    sudo ln -sf ~/.config/$dir/* /root/.config/$dir/
done
sudo update-initramfs -u
sudo update-grub

echo "========================================================================"
echo "Install custom themes and change Papirus folders color"
echo "========================================================================"

sh ~/scripts/install-custom-themes.sh
if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi
papirus-folders -C adwaita --theme Papirus-Dark

echo "========================================================================"
echo "Run system detect script to update device-specific configuration files"
echo "========================================================================"

bash system-detect.sh

echo "========================================================================"
echo "Update x-terminal-emulator and x-www-browser settings"
echo "========================================================================"

sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
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
sed -i "s/\/user\//\/$(whoami)\//" ~/.config/gtk-3.0/bookmarks ~/.gtkrc-2.0 \
~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's/"top": 0,/"top": 1,/' ~/.config/fastfetch/config.jsonc
sed -i 's/brave/brave-browser/' ~/.config/i3/config
sed -i -e '/mate-polkit/d' -e '/xbindkeys/d' -e '/at-spi/d' ~/.config/i3/startup.conf
sed -i -e 's/scheme_path=.*/scheme_path=\/usr\/share\/qt5ct\/colors\/airy\.conf/' \
-e 's/custom_palette=.*/custom_palette=false/' ~/.config/qt5ct/qt5ct.conf
sed -i -e 's/scheme_path=.*/scheme_path=\/usr\/share\/qt6ct\/colors\/airy\.conf/' \
-e 's/custom_palette=.*/custom_palette=false/' ~/.config/qt6ct/qt6ct.conf
sed -i 's/has imv, .* X, flag f = imv/X, flag f = \/usr\/libexec\/imv\/imv/' \
~/.config/ranger/rifle.conf
sed -i 's/gif=mpv/gif=imv/' ~/.config/mimeapps.list
echo "i3 installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/dots
rm -rf ~/scripts

clear
echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
