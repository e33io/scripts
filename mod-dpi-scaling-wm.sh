#!/bin/bash

# =====================================================================
# Update standalone window manager configs from 192 dpi (HiDPI scaling)
# to 96 dpi (non-HiDPI scaling)
# URL: https://github.com/e33io/scripts/blob/main/mod-dpi-scaling-wm.sh
# ---------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =====================================================================

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

# update index.theme (cursor size)
sed -i 's/Size=48/Size=24/' $HOME/.icons/default/index.theme

# update fonts.conf (font DPI)
sed -i 's/<double>192<\/double>/<double>96<\/double>/' $HOME/.config/fontconfig/fonts.conf

# update .profile (comments out the HiDPI environment variables)
sed -i 's/export GDK_SCALE=2/#export GDK_SCALE=2/' $HOME/.profile
sed -i 's/export GDK_DPI_SCALE=0\.5/#export GDK_DPI_SCALE=0\.5/' $HOME/.profile
sed -i 's/export QT_AUTO_SCREEN_SET_FACTOR=0/#export QT_AUTO_SCREEN_SET_FACTOR=0/' $HOME/.profile
sed -i 's/export QT_SCALE_FACTOR=2/#export QT_SCALE_FACTOR=2/' $HOME/.profile
sed -i 's/export QT_FONT_DPI=96/#export QT_FONT_DPI=96/' $HOME/.profile

# update .gtkrc-2.0* (comments out the HiDPI GTK2 icon sizes)
sed -i 's/gtk-icon-sizes="gtk-menu=32,32:gtk-button=32,32"/#gtk-icon-sizes="gtk-menu=32,32:gtk-button=32,32"/' $HOME/.gtkrc-2.0*

# update rofi/config.rasi (rofi DPI)
sed -i 's/dpi: 192;/dpi: 96;/' $HOME/.config/rofi/config.rasi

# update floating-window-settings.rasi (rofi window border size)
sed -i 's/border:.*4px;/border:           2px;/' $HOME/.config/rofi/themes/floating-window-settings.rasi

# update dunstrc (dunst scaling)
sed -i 's/scale = 2/scale = 1/' $HOME/.config/dunst/dunstrc

# update slick-greeter.conf (DPI mode and cursor size)
sudo sed -i 's/enable-hidpi=on/enable-hidpi=auto/' /etc/lightdm/slick-greeter.conf
sudo sed -i 's/cursor-theme-size=48/cursor-theme-size=24/' /etc/lightdm/slick-greeter.conf

# update plymouthd.conf (scaling)
if [ -f "/etc/debian_version" ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo update-initramfs -u
fi

# i3wm specific configs
if [ -d "$HOME/.config/i3" ]; then
    # update i3/config (floating window sizes)
    sed -i 's/set 1080 1080/set 540 540/' $HOME/.config/i3/config
    sed -i 's/set 1280 1080/set 640 540/' $HOME/.config/i3/config
    sed -i 's/set 1440 1080/set 720 540/' $HOME/.config/i3/config
    sed -i 's/set 1440 1152/set 720 576/' $HOME/.config/i3/config
    sed -i 's/set 1440 1280/set 720 640/' $HOME/.config/i3/config
    sed -i 's/set 1440 900/set 720 450/' $HOME/.config/i3/config
    sed -i 's/set 1600 1600/set 800 800/' $HOME/.config/i3/config
    sed -i 's/set 1728 1188/set 864 594/' $HOME/.config/i3/config
    sed -i 's/set 1920 1280/set 960 640/' $HOME/.config/i3/config
    sed -i 's/set 1920 1920/set 960 960/' $HOME/.config/i3/config
    sed -i 's/set 3000 2000/set 1500 1000/' $HOME/.config/i3/config
    # update i3status.conf (window title width in bar)
    sed -i 's/min_width = 2990/min_width = 1495/' $HOME/.config/i3/i3status.conf
fi

# JWM specific configs
if [ -f "$HOME/.config/jwm/jwmrc" ]; then
    # update jwm configs (window sizes and window decorations)
    sed -i 's/<Option>height:1028/<Option>height:514/' $HOME/.config/jwm/windows
    sed -i 's/<Option>height:1188/<Option>height:594/' $HOME/.config/jwm/windows
    sed -i 's/<Option>height:1296/<Option>height:648/' $HOME/.config/jwm/windows
    sed -i 's/<Option>height:1536/<Option>height:768/' $HOME/.config/jwm/windows
    sed -i 's/<Option>height:1728/<Option>height:864/' $HOME/.config/jwm/windows
    sed -i 's/<Option>width:1364/<Option>width:682/' $HOME/.config/jwm/windows
    sed -i 's/<Option>width:1440/<Option>width:720/' $HOME/.config/jwm/windows
    sed -i 's/<Option>width:1536/<Option>width:768/' $HOME/.config/jwm/windows
    sed -i 's/<Option>width:1728/<Option>width:864/' $HOME/.config/jwm/windows
    sed -i 's/<Option>x:1152/<Option>x:576/' $HOME/.config/jwm/windows
    sed -i 's/<Option>x:1200/<Option>x:600/' $HOME/.config/jwm/windows
    sed -i 's/<Option>x:1594/<Option>x:797/' $HOME/.config/jwm/windows
    sed -i 's/<Option>y:312/<Option>y:156/' $HOME/.config/jwm/windows
    sed -i 's/<Option>y:566/<Option>y:283/' $HOME/.config/jwm/windows
    sed -i 's/<Option>y:725/<Option>y:362/' $HOME/.config/jwm/windows
    sed -i 's/<Width>4/<Width>2/' $HOME/.config/jwm/themes/*
    sed -i 's/<Height>37/<Height>19/' $HOME/.config/jwm/themes/*
    # update rofi/config.rasi (yoffset position)
    sed -i 's/yoffset: -275;/yoffset: -180;/' $HOME/.config/rofi/config.rasi
fi
