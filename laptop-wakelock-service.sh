#!/bin/bash

# ===============================================================================
# Lock the screen on resume from suspend (using i3lock), for laptop use
# URL: https://git.sr.ht/~e33io/scripts/tree/main/item/laptop-wakelock-service.sh
# -------------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# ===============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "#########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "#########################################################"
    exit 1
fi

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

echo "#########################################################"
echo "The wakelock.service file was added and enabled."
echo "#########################################################"
