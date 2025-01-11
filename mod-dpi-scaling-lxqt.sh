#!/bin/bash

# =======================================================================
# Update LXQt configs from 192 dpi (HiDPI scaling)
# to standard 96 dpi (non-HiDPI scaling)
# URL: https://github.com/e33io/scripts/blob/main/mod-dpi-scaling-lxqt.sh
# -----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

# update .Xresources (cursor size, DPI and border spacing)
sed -i 's/Xcursor\.size.*48/Xcursor\.size:  24/' $HOME/.Xresources
sed -i 's/Xft\.dpi.*192/Xft\.dpi:       96/' $HOME/.Xresources
sed -i 's/internalBorder.*14/internalBorder:  7/' $HOME/.Xresources

# update .profile (comments out the HiDPI environment variables)
sed -i 's/export GDK_SCALE=2/#export GDK_SCALE=2/' $HOME/.profile
sed -i 's/export GDK_DPI_SCALE=0\.5/#export GDK_DPI_SCALE=0\.5/' $HOME/.profile
sed -i 's/export QT_AUTO_SCREEN_SET_FACTOR=0/#export QT_AUTO_SCREEN_SET_FACTOR=0/' $HOME/.profile
sed -i 's/export QT_SCALE_FACTOR=2/#export QT_SCALE_FACTOR=2/' $HOME/.profile
sed -i 's/export QT_FONT_DPI=96/#export QT_FONT_DPI=96/' $HOME/.profile

# update index.theme (cursor size)
sed -i 's/Size=48/Size=24/' $HOME/.icons/default/index.theme

# update fonts.conf (font DPI)
sed -i 's/<double>192<\/double>/<double>96<\/double>/' $HOME/.config/fontconfig/fonts.conf

# update .gtkrc-2.0* (comments out the HiDPI GTK2 icon sizes)
sed -i 's/gtk-icon-sizes="gtk-menu=32,32:gtk-button=32,32"/#gtk-icon-sizes="gtk-menu=32,32:gtk-button=32,32"/' $HOME/.gtkrc-2.0*

# update panel.conf (panel size)
sed -i 's/panelSize=24/panelSize=26/' $HOME/.config/lxqt/panel.conf

# update xfwm4.xml (window theme)
sed -i 's/"theme" type="string" value="System-40"/"theme" type="string" value="System-22"/' $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml

# update dunstrc (dunst scaling)
if [ -f "$HOME/.config/dunst/dunstrc" ]; then
    sed -i 's/scale = 2/scale = 1/' $HOME/.config/dunst/dunstrc
fi

# update slick-greeter.conf (DPI mode and cursor size)
sudo sed -i 's/enable-hidpi=on/enable-hidpi=auto/' /etc/lightdm/slick-greeter.conf
sudo sed -i 's/cursor-theme-size=48/cursor-theme-size=24/' /etc/lightdm/slick-greeter.conf

# update plymouthd.conf (scaling)
if [ -f "/etc/debian_version" ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo update-initramfs -u
fi
