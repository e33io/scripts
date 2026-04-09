#!/bin/bash

# =============================================================================
# Install spice-vdagent and update window manager configs
# URL: https://github.com/e33io/scripts/blob/main/mod-virt-machines.sh
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

# install spice-vdagent
sudo pacman -S --noconfirm --needed spice-vdagent

# make autostart dir
mkdir -p ~/.config/autostart

# add audio-default.desktop file
printf "%s\n" "[Desktop Entry]" "Type=Application" "Name=audio-default" "Comment=set default volume level" \
"Exec=sh -c 'sleep 2; pactl set-sink-volume @DEFAULT_SINK@ 75%'" "Icon=xfce4-mixer" "StartupNotify=false" \
"Terminal=false" "NoDisplay=true" > ~/.config/autostart/audio-default.desktop

# add xrandr-vm.desktop file
printf "%s\n" "[Desktop Entry]" "Version=1.0" "Type=Application" "Name=xrandr-vm" \
"Comment=Set xrandr resolution" "Exec=sh -c 'xrandr -s 3840x2160'" "StartupNotify=false" \
"Terminal=false" "NoDisplay=true" > ~/.config/autostart/xrandr-vm.desktop
# update xrandr monitor resolution if needed
Xft_dpi=$(grep -E '^Xft\.dpi' ~/.Xresources 2>/dev/null | grep -Eo '[0-9]+')
if [ "$Xft_dpi" = "96" ]; then
    sed -i 's/3840x2160/1920x1080/' ~/.config/autostart/xrandr-vm.desktop
fi

# update lightdm Xgsession file
sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession

# update plymouthd.conf file
sudo sed -i 's/DeviceScale=2/DeviceScale=1/' /etc/plymouth/plymouthd.conf
sudo mkinitcpio -p linux
