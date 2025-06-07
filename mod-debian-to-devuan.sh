#!/bin/bash

# =======================================================================
# Update Debian configs for use with Devuan
# URL: https://github.com/e33io/scripts/blob/main/mod-debian-to-devuan.sh
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

echo "################################################################"
echo "Replace pipewire with pulseaudio"
echo "################################################################"

sudo apt -y purge pipewire*
sudo apt -y autoremove
sudo apt -y autoclean
sudo apt -y install pulseaudio

echo "################################################################"
echo "Replace systemctl with loginctl"
echo "################################################################"

sed -i 's/systemctl/loginctl/g' $HOME/.local/bin/i3lock-suspend.sh
sed -i 's/systemctl/loginctl/g' $HOME/.local/bin/rofi-power.sh
sed -i 's/systemctl/loginctl/g' $HOME/.bashrc

echo "################################################################"
echo "Set default mute and default volume level"
echo "################################################################"

if [ -d "$HOME/.config/i3" ]; then
    echo '# Set default mute and default volume level
exec --no-startup-id sleep 1 && pactl set-sink-mute @DEFAULT_SINK@ false && $refresh_i3status
exec --no-startup-id sleep 6 && pactl set-sink-volume @DEFAULT_SINK@ 15% && $refresh_i3status' | tee -a $HOME/.config/i3/config > /dev/null
fi

echo "################################################################"
echo "Reboot the system or logout/login now to complete changes"
echo "################################################################"
