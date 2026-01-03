#!/bin/bash

# =============================================================================
# Update window manager configs to use xsecurelock instead of i3lock
# URL: https://github.com/e33io/scripts/blob/main/mod-wm-lock.sh
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

# install xsecurelock
if [ -f /etc/debian_version ]; then
    sudo apt -y install xsecurelock
fi
if [ -f /etc/pacman.conf ]; then
    sudo pacman -S --noconfirm --needed xsecurelock
fi

# i3wm specific configs
if [ -d ~/.config/i3 ]; then
    # update xss-lock command to use xsecurelock
    sed -i 's/xss-lock -l .*/xss-lock -l -- xsecurelock/' ~/.config/i3/startup.conf
    # update lock session keybinding to use xset
    sed -i 's/loginctl lock-session/xset s activate/' ~/.config/i3/config
fi

# JWM specific configs
if [ -d ~/.config/jwm ]; then
    # update xss-lock command to use xsecurelock
    sed -i 's/xss-lock -l .*/xss-lock -l -- xsecurelock/' ~/.config/jwm/autostart
    # update lock session keybinding to use xset
    sed -i 's/loginctl lock-session/xset s activate/' ~/.config/jwm/jwmrc
fi

# update rofi-power.sh lock option to use xset
if [ -f ~/.local/bin/rofi-power.sh ]; then
    sed -i 's/loginctl lock-session/xset s activate/' ~/.local/bin/rofi-power.sh
fi

# update .profile with xsecurelock settings
printf '%s\n' '' '# Set XSecureLock options' 'export XSECURELOCK_AUTH_FOREGROUND_COLOR="#ffffff"' \
'export XSECURELOCK_AUTH_BACKGROUND_COLOR="#202a36"' 'export XSECURELOCK_BACKGROUND_COLOR="#202a36"' \
'export XSECURELOCK_FONT="Inter:size=16"' 'export XSECURELOCK_BLANK_TIMEOUT="1"' \
'export XSECURELOCK_BLANK_DPMS_STATE="off"' 'export XSECURELOCK_SHOW_KEYBOARD_LAYOUT="0"' \
'export XSECURELOCK_KEY_XF86AudioMute_COMMAND="pactl set-sink-mute @DEFAULT_SINK@ toggle"' \
'export XSECURELOCK_KEY_XF86AudioLowerVolume_COMMAND="pactl set-sink-volume @DEFAULT_SINK@ -5%"' \
'export XSECURELOCK_KEY_XF86AudioRaiseVolume_COMMAND="pactl set-sink-volume @DEFAULT_SINK@ +5%"' \
'export XSECURELOCK_KEY_XF86AudioPrev_COMMAND="playerctl --all-players previous"' \
'export XSECURELOCK_KEY_XF86AudioPlay_COMMAND="playerctl --all-players play-pause"' \
'export XSECURELOCK_KEY_XF86AudioNext_COMMAND="playerctl --all-players next"' \
| tee -a ~/.profile > /dev/null
