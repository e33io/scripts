#!/bin/bash

# =============================================================================
# Debian Linux - Install Openbox
# URL: https://github.com/e33io/scripts/blob/main/debian-install-openbox.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Use with a minimal installation of Debian Linux to install the Openbox window
# manager and a base set of apps for a ready-to-use desktop session.
# -----------------------------------------------------------------------------
# The default configuration is for use with HiDPI monitors
# (192 dpi settings for 2x scaling), but there is an option
# at the end of the script that lets you change to standard
# HD monitors (96 dpi settings for 1x scaling).
# -----------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh debian-install-openbox.sh
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "This script MUST NOT be run as root user."
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
echo "Install Openbox and other packages"
echo "========================================================================"

sudo apt -y install openbox lxappearance-obconf xfce4-panel xfce4-pulseaudio-plugin xfce4-battery-plugin \
xfce4-docklike-plugin xfce4-windowck-plugin network-manager-gnome i3lock rofi dunst dex wmctrl xdotool \
xbindkeys xssproxy xsel xclip xinput x11-utils upower gvfs-fuse gvfs-backends nfs-common cifs-utils playerctl \
feh lxappearance qt*ct adwaita-qt* gnome-themes-extra papirus-icon-theme breeze-icon-theme fonts-dejavu \
fonts-noto-color-emoji mate-polkit-bin lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings plymouth \
plymouth-themes kitty python3-pypillowfight xterm lazygit fastfetch htop cmus cava cmatrix ncal micro ranger \
ueberzug caca-utils highlight atool w3m poppler-utils mediainfo fzf libimage-exiftool-perl apt-transport-https \
curl rsync dconf-cli thunar thunar-archive-plugin tumbler-plugins-extra ffmpegthumbnailer heif-thumbnailer \
heif-gdk-pixbuf engrampa pipewire-audio pulseaudio-utils pavucontrol-qt synaptic timeshift mintstick scrot \
atril imv mpv parole mousepad galculator filezilla gpick darktable gimp inkscape libreoffice-calc \
libreoffice-draw libreoffice-impress libreoffice-writer libreoffice-gtk3

echo "========================================================================"
echo "Remove unneeded/redundant packages"
echo "========================================================================"

sudo apt -y remove pavucontrol
sudo apt -y autoremove && sudo apt -y autoclean

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

git clone https://github.com/e33io/dotfiles $HOME/dotfiles
git clone https://github.com/e33io/extra $HOME/extra

echo "========================================================================"
echo "Copy custom configuration files"
echo "========================================================================"

cp -R $HOME/dotfiles/.config $HOME
cp -R $HOME/dotfiles/.icons $HOME
cp -R $HOME/dotfiles/.local $HOME
cp -R $HOME/dotfiles/.bashrc $HOME
cp -R $HOME/dotfiles/.fehbg $HOME
cp -R $HOME/dotfiles/.gtkrc* $HOME
cp -R $HOME/dotfiles/.profile $HOME
cp -R $HOME/dotfiles/.xbindkeysrc $HOME
cp -R $HOME/dotfiles/.Xresources $HOME
cp -R $HOME/extra/openbox/.config $HOME
cp -R $HOME/extra/openbox/.themes $HOME
sudo cp -R $HOME/dotfiles/etc/default /etc
sudo cp -R $HOME/dotfiles/etc/lightdm /etc
sudo cp -R $HOME/dotfiles/etc/network /etc
sudo cp -R $HOME/dotfiles/etc/plymouth /etc
sudo cp -R $HOME/dotfiles/usr/share /usr
sudo mkdir -p /boot/grub/fonts
sudo cp -R /usr/share/grub/ter-* /boot/grub/fonts
sudo mkdir -p /root/.config/gtk-3.0
sudo mkdir -p /root/.config/micro
sudo mkdir -p /root/.config/qt5ct
sudo mkdir -p /root/.config/qt6ct
sudo ln -sf $HOME/.config/gtk-3.0/* /root/.config/gtk-3.0
sudo ln -sf $HOME/.config/micro/* /root/.config/micro
sudo ln -sf $HOME/.config/qt5ct/* /root/.config/qt5ct
sudo ln -sf $HOME/.config/qt6ct/* /root/.config/qt6ct
sudo ln -sf $HOME/.gtkrc-2.0 /root/.gtkrc-2.0
sudo update-initramfs -u
sudo update-grub

echo "========================================================================"
echo "Add user .bash_profile and .xsessionrc files"
echo "========================================================================"

printf '%s\n' 'if [ -f ~/.profile ]; then' '    . ~/.profile' 'fi' \
| tee $HOME/.bash_profile $HOME/.xsessionrc > /dev/null

if [ ! -f "$HOME/.install-info" ]; then
    echo "========================================================================"
    echo "Update root .bashrc file"
    echo "========================================================================"

    printf '%s\n' '' '# Set command prompt' 'PS1="\[\e[01;31m\]\u \w/#\[\e[m\] "' \
    | sudo tee -a /root/.bashrc > /dev/null
fi

clear
while true; do
    echo "========================================================================"
    echo "The option below lets you select a configuration specific"
    echo "to your monitor type for proper display scaling."
    echo "========================================================================"
    echo "   1) Standard HD (96 dpi settings for 1x scaling)"
    echo "   2) HiDPI (192 dpi settings for 2x scaling)"
    echo "----------------------------------------------------------------"

    read -p "What type of monitor are you using? " n
    case $n in
        1) echo "You chose Standard HD (96 dpi) monitor";
           sh $HOME/scripts/mod-dpi-scaling-wm.sh;
           break;;
        2) echo "You chose HiDPI (192 dpi) monitor";
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

if command -v hostnamectl > /dev/null 2>&1; then
    pc_type="$(hostnamectl chassis)"
    if [ $pc_type = laptop ] || [ $pc_type = notebook ] \
        || [ $pc_type = portable ]; then
        echo "========================================================================"
        echo "Modify window manager configs for laptop use"
        echo "========================================================================"

        sh $HOME/scripts/mod-wm-laptop.sh
    elif [ $pc_type = vm ]; then
        echo "========================================================================"
        echo "Install spice-vdagent and update VM-specific configs"
        echo "========================================================================"

        sh $HOME/scripts/mod-virt-machines.sh
    fi
fi

echo "========================================================================"
echo "Update x-terminal-emulator and x-www-browser settings"
echo "========================================================================"

sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
sudo update-alternatives --set x-www-browser /usr/bin/brave-browser-stable

if [ -f "/etc/devuan_version" ]; then
    echo "========================================================================"
    echo "Modify Debian configs for use with Devuan Linux"
    echo "========================================================================"

    sh $HOME/scripts/mod-debian-to-devuan.sh
fi

echo "========================================================================"
echo "Change Papirus folders color"
echo "========================================================================"

if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi
papirus-folders -C adwaita --theme Papirus-Dark

echo "========================================================================"
echo "Add bookmarks and clean up user directory"
echo "========================================================================"

xdg-user-dirs-update
echo "file:///home/$(whoami)/Downloads
file:///home/$(whoami)/Documents
file:///home/$(whoami)/Pictures
file:///home/$(whoami)/Videos
file:///home/$(whoami)/Music" > $HOME/.config/gtk-3.0/bookmarks
sed -i 's/16, 37/16, 56/' $HOME/.config/dunst/dunstrc
sed -i '/mate-polkit/d' $HOME/.config/openbox/autostart
sed -i '/xbindkeys/d' $HOME/.config/openbox/autostart
sed -i '/at-spi/d' $HOME/.config/openbox/autostart
sed -i '/xsetroot/d' $HOME/.config/openbox/autostart
sed -i 's/Dmenu/Floating/' $HOME/.config/rofi/config.rasi
sed -i 's/has imv, .* X, flag f = imv/X, flag f = \/usr\/libexec\/imv\/imv/' $HOME/.config/ranger/rifle.conf
sed -i "s/home\/.*\/Desktop/home\/$(whoami)\/Desktop/" $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i "s/~\/\.gtkrc-2\.0\.mine/\/home\/$(whoami)\/\.gtkrc-2\.0\.mine/" $HOME/.gtkrc-2.0
printf "%s\n" "" "# Set XDG_CURRENT_DESKTOP" "export XDG_CURRENT_DESKTOP=openbox" \
| tee -a $HOME/.profile > /dev/null
cp -R $HOME/scripts/set-theming-openbox.sh $HOME/.local/bin/set-theming-openbox
echo "Openbox installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a $HOME/.install-info > /dev/null
if ! command -v i3 > /dev/null 2>&1; then
    rm -rf $HOME/.config/i3
fi
rm -rf $HOME/dotfiles
rm -rf $HOME/extra
rm -rf $HOME/scripts

echo "========================================================================"
echo "All done, you can now run other commands or reboot the PC"
echo "========================================================================"
