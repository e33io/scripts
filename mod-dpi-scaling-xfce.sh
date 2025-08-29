#!/bin/bash

# =============================================================================
# Update Xfce configs from "Window Scaling 2x" (HiDPI)
# to "Window Scaling 1x" (non-HiPDI)
# URL: https://github.com/e33io/scripts/blob/main/mod-dpi-scaling-xfce.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

# update xsettings.xml (cursor size and window scaling)
sed -i 's/"CursorThemeSize" type="int" value="48"/"CursorThemeSize" type="int" value="24"/' \
$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
sed -i 's/"WindowScalingFactor" type="int" value="2"/"WindowScalingFactor" type="int" value="1"/' \
$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

# update xfwm4.xml (window theme)
sed -i 's/"theme" type="string" value="System-40"/"theme" type="string" value="System-22"/' \
$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml

# update .profile (comments out the Qt HiDPI environment variables)
sed -i 's/export QT_AUTO_SCREEN_SET_FACTOR=0/#export QT_AUTO_SCREEN_SET_FACTOR=0/' $HOME/.profile
sed -i 's/export QT_SCALE_FACTOR=2/#export QT_SCALE_FACTOR=2/' $HOME/.profile
sed -i 's/export QT_FONT_DPI=96/#export QT_FONT_DPI=96/' $HOME/.profile

# update .Xresources (font size and border spacing)
sed -i 's/XTerm\*faceSize.*20/XTerm*faceSize:        10/' $HOME/.Xresources
sed -i 's/XTerm\*internalBorder.*14/XTerm*internalBorder:  7/' $HOME/.Xresources

# update Xgsession script for lightdm-gtk-greeter (GTK scaling)
if [ -f "/etc/lightdm/Xgsession" ]; then
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

# update plymouthd.conf (scaling)
if [ -f "/etc/debian_version" ]; then
    sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
    sudo update-initramfs -u
fi
