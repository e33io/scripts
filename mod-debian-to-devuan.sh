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

clear

if { [ -d "$HOME/.config/i3" ] || [ -d "$HOME/.config/jwm" ]; }; then
    while true; do
        echo "################################################################"
        echo "The option below lets you select a configuration"
        echo "specific to your computer type."
        echo "################################################################"
        echo "   1) Desktop"
        echo "   2) Laptop"
        echo "----------------------------------------------------------------"

        read -p "What type of computer are you using? " n
        case $n in
            1) echo "You chose Desktop computer";
               break;;
            2) echo "You chose Laptop computer";
               sh mod-wm-laptop.sh;
               break;;
            *) echo "Invalid selection, please enter a number from the list.";;
        esac
    done
fi

if [ -d "$HOME/.config/i3" ]; then
    echo "################################################################"
    echo "Set default mute and default volume level"
    echo "################################################################"

    echo '# Set default mute and default volume level
exec --no-startup-id sleep 1 && pactl set-sink-mute @DEFAULT_SINK@ false && $refresh_i3status
exec --no-startup-id sleep 6 && pactl set-sink-volume @DEFAULT_SINK@ 15% && $refresh_i3status' | tee -a $HOME/.config/i3/config > /dev/null
fi

echo "################################################################"
echo "Replace systemctl with loginctl"
echo "################################################################"

if [ -f "$HOME/.local/bin/lock-suspend.sh" ]; then
    sed -i 's/systemctl/loginctl/g' $HOME/.local/bin/lock-suspend.sh
fi
if [ -f "$HOME/.local/bin/rofi-power.sh" ]; then
    sed -i 's/systemctl/loginctl/g' $HOME/.local/bin/rofi-power.sh
fi
sed -i 's/systemctl/loginctl/g' $HOME/.bashrc

echo "################################################################"
echo "Replace pipewire with pulseaudio"
echo "################################################################"

sudo apt -y purge pipewire*
sudo apt -y autoremove
sudo apt -y autoclean
sudo apt -y install pulseaudio

echo "################################################################"
echo "Reboot the system or logout/login now to complete changes"
echo "################################################################"
