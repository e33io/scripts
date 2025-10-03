#!/bin/bash

# =============================================================================
# Update Debian configs for use with Devuan Linux
# URL: https://github.com/e33io/scripts/blob/main/mod-debian-to-devuan.sh
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

clear
if { [ -d "$HOME/.config/i3" ] || [ -d "$HOME/.config/jwm" ] || [ -d "$HOME/.config/dk" ] \
    || [ -d "$HOME/.config/openbox" ]; }; then
    while true; do
        echo "========================================================================"
        echo "The option below lets you select a configuration"
        echo "specific to your computer type."
        echo "========================================================================"
        echo "  1) Desktop"
        echo "  2) Laptop"
        echo "------------------------------------------------------------------------"

        read -p "What type of computer are you using? " n
        case $n in
            1) echo "You chose Desktop computer";
               break;;
            2) echo "You chose Laptop computer";
               curl -s https://raw.githubusercontent.com/e33io/scripts/refs/heads/main/mod-wm-laptop.sh | sh;
               break;;
            *) echo "Invalid selection, please enter a number from the list.";;
        esac
    done
fi

echo "========================================================================"
echo "Replace pipewire with pulseaudio"
echo "========================================================================"

sudo apt -y purge pipewire*
sudo apt -y autoremove
sudo apt -y autoclean
sudo apt -y install pulseaudio

echo "========================================================================"
echo "Replace systemctl with loginctl"
echo "========================================================================"

if [ -f "$HOME/.local/bin/lock-suspend.sh" ]; then
    sed -i 's/systemctl/loginctl/g' $HOME/.local/bin/lock-suspend.sh
fi
if [ -f "$HOME/.local/bin/rofi-power.sh" ]; then
    sed -i 's/systemctl/loginctl/g' $HOME/.local/bin/rofi-power.sh
fi
sed -i 's/systemctl/loginctl/g' $HOME/.bashrc

sys_vendor="$(cat /sys/class/dmi/id/sys_vendor)"
if [ $sys_vendor = QEMU ]; then
    echo "========================================================================"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "========================================================================"

    curl -s https://raw.githubusercontent.com/e33io/scripts/refs/heads/main/mod-virt-machines.sh | sh
fi

echo "========================================================================"
echo "Update grub file"
echo "========================================================================"

sudo cp -R $HOME/opt-dots/devuan/etc/default/grub /etc/default
sudo update-grub

echo "========================================================================"
echo "Set default mute and default volume level"
echo "========================================================================"

mkdir -p $HOME/.config/autostart
printf "%s\n" "[Desktop Entry]" "Version=1.0" "Type=Application" \
"Name=audio-default" "Comment=set default mute and default volume level" \
"Exec=sh -c 'sleep 1; pactl set-sink-mute @DEFAULT_SINK@ false; sleep 6; pactl set-sink-volume @DEFAULT_SINK@ 25%'" \
"Icon=xfce4-mixer" "StartupNotify=false" "Terminal=false" "NoDisplay=true" \
"Hidden=false" > $HOME/.config/autostart/audio-default.desktop
chmod +x $HOME/.config/autostart/audio-default.desktop
if [ -f "/bin/startxfce4" ]; then
    sed -i 's/25%/25%%/' $HOME/.config/autostart/audio-default.desktop
fi

echo "========================================================================"
echo "Reboot the system now to complete changes"
echo "========================================================================"
