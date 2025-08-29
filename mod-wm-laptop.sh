#!/bin/bash

# =============================================================================
# Update standalone window manager configs from desktop use to laptop use
# URL: https://github.com/e33io/scripts/blob/main/mod-wm-laptop.sh
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

# install other packages
if [ -f "/etc/debian_version" ]; then
    sudo apt -y install brightnessctl
fi
if [ -f "/etc/pacman.conf" ]; then
    sudo pacman -S --noconfirm --needed brightnessctl
fi

# i3wm specific configs
if [ -d "$HOME/.config/i3" ]; then
    # update xss-lock.desktop (add lock-suspend.sh to xss-lock command)
    sed -i 's/xss-lock -l/xss-lock -n sh ~\/\.local\/bin\/lock-suspend\.sh -l/' $HOME/.config/i3/startup.conf
    # update polybar config.ini (modules)
    sed -i 's/time pulseaudio eth tray/time battery pulseaudio wlan tray/' $HOME/.config/polybar/config.ini
    sed -i 's/label-maxlen = .*/label-maxlen = 140/' $HOME/.config/polybar/config.ini
fi

# JWM specific configs
if [ -d "$HOME/.config/jwm" ]; then
    # update xss-lock.desktop (add lock-suspend.sh to xss-lock command)
    sed -i 's/xss-lock -l/xss-lock -n sh ~\/\.local\/bin\/lock-suspend\.sh -l/' $HOME/.config/jwm/startup
    # update polybar config.ini (modules)
    sed -i 's/time pulseaudio eth tray/time battery pulseaudio wlan tray/' $HOME/.config/polybar/config.ini
    sed -i 's/label-maxlen = .*/label-maxlen = 140/' $HOME/.config/polybar/config.ini
fi
