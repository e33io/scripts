#!/bin/bash

# =============================================================================
# Install spice-vdagent and update VM-specific configs
# URL: https://github.com/e33io/scripts/blob/main/mod-virt-machines.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =============================================================================

# install spice-vdagent
if [ -f "/etc/debian_version" ]; then
    sudo apt -y install spice-vdagent
fi
if [ -f "/etc/pacman.conf" ]; then
    sudo pacman -S --noconfirm --needed spice-vdagent
fi

# i3 configs
if [ -f "/bin/i3" ]; then
    mkdir -p $HOME/.config/autostart
    # add audio-default.desktop file
    printf "%s\n" "[Desktop Entry]" "Type=Application" "Name=audio-default" "Comment=set default volume level" \
    "Exec=sh -c 'sleep 2; pactl set-sink-volume @DEFAULT_SINK@ 75%; \$refresh_i3status'" "Icon=xfce4-mixer" \
    "StartupNotify=false" "Terminal=false" "NoDisplay=true" > $HOME/.config/autostart/audio-default.desktop
    chmod +x $HOME/.config/autostart/audio-default.desktop
    # add xrandr-vm.desktop file
    printf "%s\n" "[Desktop Entry]" "Version=1.0" "Type=Application" "Name=xrandr-vm" \
    "Comment=Set xrandr resolution" "Exec=sh -c 'xrandr -s 3840x2160'" "StartupNotify=false" \
    "Terminal=false" "NoDisplay=true" > $HOME/.config/autostart/xrandr-vm.desktop
    chmod +x $HOME/.config/autostart/xrandr-vm.desktop
    # update xrandr monitor resolution if needed
    Xft_dpi=$(grep Xft.dpi ~/.Xresources | grep -Eo '[0-9]+')
    if [ $Xft_dpi = 96 ]; then
        sed -i 's/3840x2160/1920x1080/' $HOME/.config/autostart/xrandr-vm.desktop
    fi
    # update lightdm Xgsession file
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

# JWM configs
if [ -f "/bin/jwm" ]; then
    mkdir -p $HOME/.config/autostart
    # add audio-default.desktop file
    printf "%s\n" "[Desktop Entry]" "Type=Application" "Name=audio-default" "Comment=set default volume level" \
    "Exec=sh -c 'sleep 2; pactl set-sink-volume @DEFAULT_SINK@ 75%'" "Icon=xfce4-mixer" "StartupNotify=false" \
    "Terminal=false" "NoDisplay=true" > $HOME/.config/autostart/audio-default.desktop
    chmod +x $HOME/.config/autostart/audio-default.desktop
    # add xrandr-vm.desktop file
    printf "%s\n" "[Desktop Entry]" "Version=1.0" "Type=Application" "Name=xrandr-vm" \
    "Comment=Set xrandr resolution" "Exec=sh -c 'xrandr -s 3840x2160'" "StartupNotify=false" \
    "Terminal=false" "NoDisplay=true" > $HOME/.config/autostart/xrandr-vm.desktop
    chmod +x $HOME/.config/autostart/xrandr-vm.desktop
    # update xrandr monitor resolution if needed
    Xft_dpi=$(grep Xft.dpi ~/.Xresources | grep -Eo '[0-9]+')
    if [ $Xft_dpi = 96 ]; then
        sed -i 's/3840x2160/1920x1080/' $HOME/.config/autostart/xrandr-vm.desktop
    fi
    # update lightdm Xgsession file
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

# Xfce configs
if [ -f "/bin/startxfce4" ]; then
    mkdir -p $HOME/.config/autostart
    # add audio-default.desktop file
    printf "%s\n" "[Desktop Entry]" "Version=1.0" "Type=Application" "Name=audio-default" \
    "Comment=set default volume level" "Exec=sh -c 'sleep 2; pactl set-sink-volume @DEFAULT_SINK@ 75%%'" \
    "Icon=xfce4-mixer" "StartupNotify=false" "Terminal=false" "NoDisplay=true" \
    "Hidden=false" > $HOME/.config/autostart/audio-default.desktop
    chmod +x $HOME/.config/autostart/audio-default.desktop
    # update lightdm Xgsession file
    sudo sed -i 's/GDK_SCALE=2/GDK_SCALE=1/' /etc/lightdm/Xgsession
fi

# Gnome configs
if [ -f "/bin/gnome-shell" ]; then
    mkdir -p $HOME/.config/autostart
    # add audio-default.desktop file
    printf "%s\n" "[Desktop Entry]" "Version=1.0" "Type=Application" "Name=audio-default" \
    "Comment=set default volume level" "Exec=sh -c 'sleep 2; pactl set-sink-volume @DEFAULT_SINK@ 75%%'" \
    "Icon=xfce4-mixer" "StartupNotify=false" "Terminal=false" "NoDisplay=true" \
    "Hidden=false" > $HOME/.config/autostart/audio-default.desktop
    chmod +x $HOME/.config/autostart/audio-default.desktop
fi
