#!/bin/bash

# =============================================================================
# Update window manager configs from desktop use to laptop/notebook use
# URL: https://github.com/e33io/scripts/blob/main/mod-wm-laptop.sh
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

# install other packages
if [ -f /etc/debian_version ]; then
    sudo apt -y install brightnessctl libinput-tools wmctrl
fi
if [ -f /etc/pacman.conf ]; then
    sudo pacman -S --noconfirm --needed brightnessctl libinput-tools wmctrl
fi

# i3wm specific configs
if [ -d ~/.config/i3 ]; then
    # update startup.conf (xss-lock command)
    sed -i 's|xss-lock -l -- i3lock -n -i ~/.cache/i3lock/lock.png|'\
    'xss-lock -- sh -c "i3lock -i ~/.cache/i3lock/lock.png '\
    '\&\& systemctl suspend"|' ~/.config/i3/startup.conf
    # update polybar config.ini (modules)
    sed -i -e 's/time pulseaudio eth tray/time battery pulseaudio wlan tray/' \
    -e 's/maxlen = .*/maxlen = 140/' \
    -e 's/%a %b/%b/' \
    -e 's/%M:%S/%M/' ~/.config/i3/polybar/config.ini
fi
