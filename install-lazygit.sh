#!/bin/bash

# ============================================================================
# Install Lazygit (terminal UI for git commands)
# URL: https://github.com/e33io/scripts/blob/main/install-lazygit.sh
# ----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Please see https://github.com/jesseduffield/lazygit for a complete reference
# ----------------------------------------------------------------------------
# NOTE: Only use with Debian 12 Bookworm
# ============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

release="$(lsb_release -a | awk '/Codename:/ { print $2 }')"
if [ ! $release = bookworm ]; then
    echo "################################################################"
    echo "Install Lazygit script is NOT compatible with your"
    echo "version of Linux, and it will exit now without"
    echo "running or making any changes."
    echo "################################################################"
    exit 1
fi

echo "################################################################"
echo "Install Lazygit latest release"
echo "################################################################"

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

echo "################################################################"
echo "Clean up directory"
echo "################################################################"

rm -R $PWD/lazygit.tar.gz
rm -R $PWD/lazygit

echo "################################################################"
echo "All done, Lazygit is now installed"
echo "################################################################"
