#!/bin/bash

# =============================================================================
# Update standalone window manager configs from 192 dpi (HiDPI scaling)
# to 96 dpi (non-HiDPI scaling)
# URL: https://github.com/e33io/scripts/blob/main/mod-dpi-scaling-wm.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
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
sed -i 's/gtk-icon-sizes="gtk-menu=32,32:gtk-button=32,32"/#gtk-icon-sizes="gtk-menu=32,32:gtk-button=32,32"/' \
$HOME/.gtkrc-2.0*

# update rofi/config.rasi (rofi DPI)
sed -i 's/dpi: 192;/dpi: 96;/' $HOME/.config/rofi/config.rasi

# update floating-window-settings.rasi (rofi window border size)
sed -i 's/border:.*4px;/border:           2px;/' $HOME/.config/rofi/themes/floating-window-settings.rasi

# update dunstrc (dunst scaling)
sed -i 's/scale = 2/scale = 1/' $HOME/.config/dunst/dunstrc

# update Xgsession script for lightdm-gtk-greeter (GTK scaling)
if [ -f "/etc/lightdm/Xgsession" ]; then
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

# update plymouthd.conf (scaling)
if [ -f "/etc/debian_version" ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo update-initramfs -u
fi
if [ -f "/etc/pacman.conf" ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo mkinitcpio -p linux
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
    # update i3/config (keybindings)
    sed -i 's/GDK_SCALE=1 brave/brave/' $HOME/.config/i3/config
    sed -i 's/GDK_SCALE=1 signal-desktop/signal-desktop/' $HOME/.config/i3/config
    # update polybar configs (sizes and scaling)
    sed -i 's/height = 40/height = 20/' $HOME/.config/i3/polybar/config.ini
    sed -i 's/;3"/;2"/' $HOME/.config/i3/polybar/config.ini
    sed -i 's/dpi = 192/dpi = 96/' $HOME/.config/i3/polybar/config.ini
    sed -i 's/tray-spacing = 12/tray-spacing = 6/' $HOME/.config/i3/polybar/config.ini
    # update rofi/config.rasi (rofi font size)
    sed -i 's/sans-serif 9"/sans-serif 9.5"/' $HOME/.config/rofi/config.rasi
fi

# JWM specific configs
if [ -d "$HOME/.config/jwm" ]; then
    # update jwm configs (window sizes and window decorations)
    sed -i 's/<Option>height:1028/<Option>height:514/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>height:1188/<Option>height:594/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>height:1296/<Option>height:648/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>height:1536/<Option>height:768/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>height:1728/<Option>height:864/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>width:1350/<Option>width:675/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>width:1440/<Option>width:720/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>width:1536/<Option>width:768/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>width:1728/<Option>width:864/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>x:1152/<Option>x:576/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>x:1200/<Option>x:600/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>x:1594/<Option>x:797/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>y:312/<Option>y:156/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>y:566/<Option>y:283/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Option>y:725/<Option>y:362/' $HOME/.config/jwm/jwmrc
    sed -i 's/height="41"/height="22"/' $HOME/.config/jwm/jwmrc
    sed -i 's/<Width>4/<Width>2/' $HOME/.config/jwm/themes/*
    sed -i 's/<Height>39/<Height>20/' $HOME/.config/jwm/themes/*
    # update jwm configs (keybindings)
    sed -i 's/GDK_SCALE=1 brave/brave/' $HOME/.config/jwm/jwmrc
    sed -i 's/GDK_SCALE=1 signal-desktop/signal-desktop/' $HOME/.config/jwm/jwmrc
    # update polybar configs (sizes and scaling)
    sed -i 's/height = 40/height = 20/' $HOME/.config/jwm/polybar/config.ini
    sed -i 's/;3"/;2"/' $HOME/.config/jwm/polybar/config.ini
    sed -i 's/dpi = 192/dpi = 96/' $HOME/.config/jwm/polybar/config.ini
    sed -i 's/tray-spacing = 12/tray-spacing = 6/' $HOME/.config/jwm/polybar/config.ini
fi

# dk specific configs
if [ -d "$HOME/.config/dk" ]; then
    # update dk dkrc configs (window sizes and window decorations)
    sed -i 's/w=1080 h=1080/w=540 h=540/' $HOME/.config/dk/dkrc
    sed -i 's/w=1280 h=1080/w=640 h=540/' $HOME/.config/dk/dkrc
    sed -i 's/w=1440 h=1080/w=720 h=540/' $HOME/.config/dk/dkrc
    sed -i 's/w=1440 h=1152/w=720 h=576/' $HOME/.config/dk/dkrc
    sed -i 's/w=1440 h=1280/w=720 h=640/' $HOME/.config/dk/dkrc
    sed -i 's/w=1440 h=900/w=720 h=450/' $HOME/.config/dk/dkrc
    sed -i 's/w=1600 h=1600/w=800 h=800/' $HOME/.config/dk/dkrc
    sed -i 's/w=1728 h=1188/w=864 h=594/' $HOME/.config/dk/dkrc
    sed -i 's/w=1920 h=1280/w=960 h=640/' $HOME/.config/dk/dkrc
    sed -i 's/w=1920 h=1920/w=960 h=960/' $HOME/.config/dk/dkrc
    sed -i 's/w=3000 h=2000/w=1500 h=1000/' $HOME/.config/dk/dkrc
    sed -i 's/gap=16/gap=8/' $HOME/.config/dk/dkrc
    sed -i 's/border width=4/border width=2/' $HOME/.config/dk/dkrc
    # update dk sxhkdrc configs (keybindings)
    if [ -f "/etc/pacman.conf" ]; then
        sed -i "s/sh -c 'GDK_SCALE=1 brave'/brave/" $HOME/.config/dk/sxhkdrc
    fi
    sed -i "s/sh -c 'GDK_SCALE=1 brave-browser'/brave-browser/" $HOME/.config/dk/sxhkdrc
    sed -i "s/sh -c 'GDK_SCALE=1 signal-desktop'/signal-desktop/" $HOME/.config/dk/sxhkdrc
    # update polybar configs (sizes and scaling)
    sed -i 's/height = 40/height = 20/' $HOME/.config/dk/polybar/config.ini
    sed -i 's/;3"/;2"/' $HOME/.config/dk/polybar/config.ini
    sed -i 's/dpi = 192/dpi = 96/' $HOME/.config/dk/polybar/config.ini
    sed -i 's/tray-spacing = 12/tray-spacing = 6/' $HOME/.config/dk/polybar/config.ini
    # update rofi/config.rasi (rofi font size)
    sed -i 's/sans-serif 9"/sans-serif 9.5"/' $HOME/.config/rofi/config.rasi
fi

# Openbox specific configs
if [ -d "$HOME/.config/openbox" ]; then
    # update openbox configs (theme version)
    sed -i 's/Openbox-Adwaita-Dark-HiDPI/Openbox-Adwaita-Dark/' $HOME/.config/openbox/rc.xml
    # update openbox configs (window font size)
    sed -i 's/size>8\.5<\/size/size>9<\/size/' $HOME/.config/openbox/rc.xml
    # update openbox configs (keybindings)
    sed -i "s/sh -c 'GDK_SCALE=1 brave-browser'/brave-browser/" $HOME/.config/openbox/rc.xml
    sed -i "s/sh -c 'GDK_SCALE=1 signal-desktop'/signal-desktop/" $HOME/.config/openbox/rc.xml
    # update xfce4-panel (height)
    sed -i 's/value="20"/value="21"/' $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
fi

# Remove unneeded .desktop files
if [ -f "$HOME/.local/share/applications/brave-browser.desktop" ]; then
    rm -rf $HOME/.local/share/applications/brave-browser.desktop
fi
if [ -f "$HOME/.local/share/applications/signal-desktop.desktop" ]; then
    rm -rf $HOME/.local/share/applications/signal-desktop.desktop
fi
