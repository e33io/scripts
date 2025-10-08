#!/bin/bash

# =============================================================================
# Modify Debian configs for use with Devuan Linux
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

if { [ -d "$HOME/.config/i3" ] || [ -d "$HOME/.config/jwm" ] || [ -d "$HOME/.config/dk" ] \
    || [ -d "$HOME/.config/openbox" ]; }; then
    if ! command -v laptop-detect > /dev/null 2>&1; then
        sudo apt -y install laptop-detect
    fi
    if laptop-detect > /dev/null 2>&1; then
        echo "========================================================================"
        echo "Modify window manager configs for laptop use"
        echo "========================================================================"

        curl -s https://raw.githubusercontent.com/e33io/scripts/refs/heads/main/mod-wm-laptop.sh | sh
    fi
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

echo "========================================================================"
echo "Remove Debian logo files"
echo "========================================================================"

sudo rm -rf /usr/share/desktop-base/debian-logos

echo "========================================================================"
echo "Update grub file"
echo "========================================================================"

printf '%s\n' 'GRUB_DEFAULT=0' 'GRUB_TIMEOUT=5' 'GRUB_DISTRIBUTOR=`( . /etc/os-release && echo ${NAME} )`' \
'GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=2"' 'GRUB_CMDLINE_LINUX=""' 'GRUB_THEME=""' 'GRUB_BACKGROUND=""' \
'GRUB_FONT=/boot/grub/fonts/ter-u16b.pf2' '#GRUB_DISABLE_OS_PROBER=false' '#GRUB_TERMINAL=console' \
'#GRUB_GFXMODE=640x480' '#GRUB_DISABLE_LINUX_UUID=true' '#GRUB_DISABLE_RECOVERY="true"' \
'#GRUB_INIT_TUNE="480 440 1"' | sudo tee /etc/default/grub > /dev/null
sudo update-initramfs -u
sudo update-grub

sys_vendor="$(cat /sys/class/dmi/id/sys_vendor)"
if [ $sys_vendor = QEMU ]; then
    echo "========================================================================"
    echo "Install spice-vdagent and update VM-specific configs"
    echo "========================================================================"

    curl -s https://raw.githubusercontent.com/e33io/scripts/refs/heads/main/mod-virt-machines.sh | sh
fi

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
if [ $sys_vendor = QEMU ]; then
    sed -i 's/@DEFAULT_SINK@ 25/@DEFAULT_SINK@ 75/' $HOME/.config/autostart/audio-default.desktop
fi

if [ -f "$HOME/.config/cava/config" ]; then
    echo "========================================================================"
    echo "Update cava config file"
    echo "========================================================================"

    sed -i 's/; method = pulse/method = pulse/' $HOME/.config/cava/config
    sed -i 's/; source = auto/source = auto/' $HOME/.config/cava/config
fi
