#!/bin/bash

# =============================================================================
# Install tick-rs (realtime ticker data in your terminal)
# URL: https://github.com/e33io/scripts/blob/main/install-tickrs.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Please see https://github.com/tarkah/tickrs for a complete reference!
# NOTE: This method is for the current user only.
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "########################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "########################################################"
    exit 1
fi

echo "########################################################"
echo "Install tickrs latest release"
echo "########################################################"

# make directories
mkdir -p $HOME/.local/applications/tickrs
mkdir -p $HOME/.local/bin

# download and extract tar
TICKRS_VERSION=$(curl -s "https://api.github.com/repos/tarkah/tickrs/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo tickrs.tar.gz "https://github.com/tarkah/tickrs/releases/download/v0.14.10/tickrs-v${TICKRS_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
tar -xf tickrs.tar.gz --directory $HOME/.local/applications/tickrs

# make symbolic link to ~/.local/bin/
ln -s $HOME/.local/applications/tickrs/tickrs $HOME/.local/bin/tickrs

echo "########################################################"
echo "Add basic starter config file"
echo "########################################################"

# make config directory
mkdir -p $HOME/.config/tickrs

# write config file
echo "symbols:
  - AMD
  - INTC
  - NVDA
  - ^DJI
  - ^GSPC
  - ^IXIC
  - BTC-USD
  - XMR-USD" > $HOME/.config/tickrs/config.yml

echo "########################################################"
echo "Clean up directory"
echo "########################################################"

rm -R $PWD/tickrs.tar.gz

echo "########################################################"
echo "All done, tickrs is now installed"
echo "########################################################"
