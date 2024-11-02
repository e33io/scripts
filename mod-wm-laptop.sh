#!/bin/bash

# =======================================================================
# Update standalone window manager configs from desktop use to laptop use
# URL: https://git.sr.ht/~e33io/scripts/tree/main/item/mod-wm-laptop.sh
# -----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

# install `light` to control screen brightness
if [ -f "/etc/debian_version" ]; then
    sudo apt -y install light
fi

# i3wm specific configs
if [ -d "$HOME/.config/i3" ]; then
    # update config (include laptop.conf instead of desktop.conf)
    sed -i 's/include ~\/\.config\/i3\/desktop\.conf/#include ~\/\.config\/i3\/desktop\.conf/' $HOME/.config/i3/config
    sed -i 's/#include ~\/\.config\/i3\/laptop\.conf/include ~\/\.config\/i3\/laptop\.conf/' $HOME/.config/i3/config
    # update i3status.conf (window title width in bar)
    sed -i 's/min_width = 2990/min_width = 2776/' $HOME/.config/i3/i3status.conf
    sed -i 's/min_width = 1495/min_width = 1388/' $HOME/.config/i3/i3status.conf
    sed -i 's/max_width = 200/max_width = 160/' $HOME/.config/i3/i3status.conf
    # update i3status.conf (status options/icons)
    sed -i 's/#order += "battery all"/order += "battery all"/' $HOME/.config/i3/i3status.conf
    sed -i 's/order += "ethernet _first_"/#order += "ethernet _first_"/' $HOME/.config/i3/i3status.conf
    sed -i 's/#order += "wireless _first_"/order += "wireless _first_"/' $HOME/.config/i3/i3status.conf
fi

# JWM specific configs
if [ -f "$HOME/.jwmrc" ]; then
    # update .jwmrc (include laptop config instead of desktop config)
    sed -i 's/<Include>\$HOME\/\.config\/jwm\/desktop<\/Include>/<!-- <Include>\$HOME\/\.config\/jwm\/desktop<\/Include> -->/' $HOME/.jwmrc
    sed -i 's/<!-- <Include>\$HOME\/\.config\/jwm\/laptop<\/Include> -->/<Include>\$HOME\/\.config\/jwm\/laptop<\/Include>/' $HOME/.jwmrc
    # update jwm/tray (status tray width)
    sed -i 's/Swallow width="434"/Swallow width="552"/' $HOME/.config/jwm/tray
    sed -i 's/Swallow width="217"/Swallow width="279"/' $HOME/.config/jwm/tray
    # update jwm-bar.sh (status options/icons)
    sed -i 's/$(time1)$(spcr)$(vol)/$(time1)$(spcr)$(bat)$(spcr)$(vol)/' $HOME/.local/bin/jwm-bar.sh
fi

# update rofi-power.sh (lock with i3lock instead of loginctl)
sed -i 's/loginctl lock-session/#loginctl lock-session/' $HOME/.local/bin/rofi-power.sh
sed -i 's/#i3lock -c 252525/i3lock -c 252525/' $HOME/.local/bin/rofi-power.sh

# write wakelock.service file
echo "[Unit]
Description=Lock the screen on resume from suspend
Before=sleep.target suspend.target

[Service]
User=$(whoami)
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/bin/i3lock -c 252525

[Install]
WantedBy=sleep.target suspend.target" | sudo tee /etc/systemd/system/wakelock.service > /dev/null

# enable wakelock service
sudo systemctl enable wakelock
