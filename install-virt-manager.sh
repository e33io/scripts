#!/bin/bash

# =============================================================================
# Install and set up virt-manager
# URL: https://github.com/e33io/scripts/blob/main/install-virt-manager.sh
# -----------------------------------------------------------------------------
# NOTE: After installing and starting the first VM,
# run command `sudo virsh net-autostart default`
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
echo "Install virt-manager"
echo "========================================================================"

if [ -f /etc/debian_version ]; then
    sudo apt -y install virt-manager
fi
if [ -f /etc/pacman.conf ]; then
    sudo pacman -S --noconfirm --needed virt-manager qemu-full libvirt dnsmasq \
    dmidecode bridge-utils edk2-ovmf
fi

echo "========================================================================"
echo "Set up virt-manager"
echo "========================================================================"

sudo sed -i -e "s/^#unix_sock_group = .*/unix_sock_group = \"libvirt\"/" \
-e "s/^#unix_sock_rw_perms = .*/unix_sock_rw_perms = \"0770\"/" /etc/libvirt/libvirtd.conf
sudo sed -i -e "s/^#user = .*/user = \"$(whoami)\"/" \
-e "s/^#group = .*/group = \"libvirt\"/" /etc/libvirt/qemu.conf
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt "$(whoami)"

echo "========================================================================"
echo "All done, virt-manager is now ready to use"
echo "========================================================================"
