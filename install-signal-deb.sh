#!/bin/bash

# =============================================================================
# Install Signal App from Signal's apt package repos
# URL: https://github.com/e33io/scripts/blob/main/install-signal-deb.sh
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

echo "========================================================================"
echo "Install dependencies"
echo "========================================================================"

sudo apt -y install apt-transport-https curl

echo "========================================================================"
echo "Install Signal App"
echo "========================================================================"

curl -fsSL https://updates.signal.org/desktop/apt/keys.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] \
https://updates.signal.org/desktop/apt xenial main" \
| sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt -y install signal-desktop

echo "========================================================================"
echo "All done, Signal App is now installed"
echo "========================================================================"
