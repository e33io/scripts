#!/bin/bash

# =============================================================================
# Make and setup a swap file
# URL: https://github.com/e33io/scripts/blob/main/make-swap-file.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Only with file systems that do not already have a swap file/partition
# -----------------------------------------------------------------------------
# NOTE: Do not use with LVM or Btrfs file systems
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

if free | awk '/^Swap:/ { exit !$2 }'; then
    echo "Swap file/partition already exists,"
    echo "no changes were made to the system."
else
    # Edit the "2G" to a different size if needed
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    printf "# swap file\n/swapfile swap swap defaults 0 0" | \
    sudo tee -a /etc/fstab > /dev/null
    # Edit the swappiness value if needed
    echo "vm.swappiness=5" | sudo tee -a /etc/sysctl.conf > /dev/null
    echo "Swap file was added to the system."
fi
