#!/bin/bash

# =======================================================================
# Update standalone window manager configs from desktop use to laptop use
# URL: https://github.com/e33io/scripts/blob/main/mod-wm-laptop.sh
# -----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

# install other packages
if [ -f "/etc/debian_version" ]; then
    sudo apt -y install brightnessctl
fi
if [ -f "/etc/pacman.conf" ]; then
    sudo pacman -S --noconfirm --needed brightnessctl
fi

# i3wm specific configs
if [ -d "$HOME/.config/i3" ]; then
    # update config (add lock-suspend.sh to xss-lock command)
    sed -i 's/xss-lock -l/xss-lock -n sh ~\/\.local\/bin\/lock-suspend\.sh -l/' $HOME/.config/i3/config
    # update i3status.conf (window title width in bar)
    sed -i 's/min_width = 2990/min_width = 2776/' $HOME/.config/i3/i3status.conf
    sed -i 's/min_width = 1495/min_width = 1388/' $HOME/.config/i3/i3status.conf
    sed -i 's/max_width = 180/max_width = 144/' $HOME/.config/i3/i3status.conf
    # update i3status.conf (status options/icons)
    sed -i 's/#order += "battery all"/order += "battery all"/' $HOME/.config/i3/i3status.conf
    sed -i 's/order += "ethernet _first_"/#order += "ethernet _first_"/' $HOME/.config/i3/i3status.conf
    sed -i 's/#order += "wireless _first_"/order += "wireless _first_"/' $HOME/.config/i3/i3status.conf
fi

# JWM specific configs
if [ -d "$HOME/.config/jwm" ]; then
    # update startup (add lock-suspend.sh to xss-lock command)
    sed -i 's/xss-lock -l/xss-lock -n sh ~\/\.local\/bin\/lock-suspend\.sh -l/' $HOME/.config/jwm/jwmrc
    # install xfce4-battery-plugin for Xfce Panel
    if [ -f "/etc/debian_version" ]; then
        sudo apt -y install xfce4-battery-plugin
    fi
    if [ -f "/etc/pacman.conf" ]; then
        sudo pacman -S --noconfirm --needed xfce4-battery-plugin
    fi
    # copy laptop-specific Xfce Panel config files
    cp -R $HOME/opt-dots/jwm/options/xfce4 $HOME/.config
fi
