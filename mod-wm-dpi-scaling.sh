#!/bin/bash

# =============================================================================
# Update window manager configs from 192 dpi (HiDPI scaling)
# to 96 dpi (non-HiDPI scaling)
# URL: https://github.com/e33io/scripts/blob/main/mod-wm-dpi-scaling.sh
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
sed -i -e 's/Xcursor\.size.*48/Xcursor\.size:  24/' \
-e 's/Xft\.dpi.*192/Xft\.dpi:       96/' \
-e 's/internalBorder.*14/internalBorder:  7/' ~/.Xresources

# update index.theme (cursor size)
sed -i 's/Size=48/Size=24/' ~/.icons/default/index.theme

# update fonts.conf (font DPI)
sed -i 's/<double>192<\/double>/<double>96<\/double>/' ~/.config/fontconfig/fonts.conf

# update .profile (comments out the HiDPI environment variables)
sed -i -e 's/export GDK_SCALE=2/#export GDK_SCALE=2/' \
-e 's/export GDK_DPI_SCALE=0\.5/#export GDK_DPI_SCALE=0\.5/' \
-e 's/export QT_AUTO_SCREEN_SET_FACTOR=0/#export QT_AUTO_SCREEN_SET_FACTOR=0/' \
-e 's/export QT_SCALE_FACTOR=2/#export QT_SCALE_FACTOR=2/' \
-e 's/export QT_FONT_DPI=96/#export QT_FONT_DPI=96/' ~/.profile

# update .gtkrc-2.0* (comments out the HiDPI GTK2 icon sizes)
sed -i 's/gtk-icon-sizes/#gtk-icon-sizes/' ~/.gtkrc-2.0*

# update rofi/config.rasi (rofi DPI)
sed -i 's/dpi: 192;/dpi: 96;/' ~/.config/rofi/config.rasi

# update floating-window-settings.rasi (rofi window border size)
sed -i 's/border:.*4px;/border:           2px;/' ~/.config/rofi/themes/floating-window-settings.rasi

# update dunstrc (dunst scaling)
sed -i 's/scale = 2/scale = 1/' ~/.config/dunst/dunstrc

# update screenshot.sh (selection line width)
sed -i 's/width=2/width=1/' ~/.local/bin/screenshot.sh

# update Xgsession script for lightdm-gtk-greeter (GTK scaling)
if [ -f /etc/lightdm/Xgsession ]; then
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

# update plymouthd.conf (scaling)
if [ -f /etc/debian_version ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo update-initramfs -u
fi
if [ -f /etc/pacman.conf ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo mkinitcpio -p linux
fi

# i3wm specific configs
if [ -d ~/.config/i3 ]; then
    # update i3/config (floating window sizes and keybindings)
    sed -i -e 's/set 1080 1080/set 540 540/' \
    -e 's/set 1280 1080/set 640 540/' \
    -e 's/set 1440 1080/set 720 540/' \
    -e 's/set 1440 1152/set 720 576/' \
    -e 's/set 1440 900/set 720 450/' \
    -e 's/set 1600 1600/set 800 800/' \
    -e 's/set 1728 1188/set 864 594/' \
    -e 's/set 1920 1280/set 960 640/' \
    -e 's/set 1920 1920/set 960 960/' \
    -e 's/GDK_SCALE=1 brave/brave/' \
    -e 's/GDK_SCALE=1 signal-desktop/signal-desktop/' ~/.config/i3/config
    # update polybar configs (sizes and scaling)
    sed -i -e 's/height = 40/height = 20/' \
    -e 's/;3"/;2"/' \
    -e 's/dpi = 192/dpi = 96/' \
    -e 's/tray-spacing = 12/tray-spacing = 6/' ~/.config/i3/polybar/config.ini
    # update rofi/config.rasi (rofi font size)
    sed -i 's/sans-serif 9"/sans-serif 9.5"/' ~/.config/rofi/config.rasi
fi

# Remove unneeded .desktop files
rm -rf ~/.local/share/applications/brave-browser.desktop
rm -rf ~/.local/share/applications/signal-desktop.desktop
