#!/bin/bash

# ===========================================================================
# Debian (post-install) Initial Setup and WM or DE Installation
# URL: https://github.com/e33io/scripts/blob/main/deb-post-install-options.sh
# ---------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE! For best results only select "standard system utilities" on the
# Software selection screen (uncheck all the rest) during the Debian
# install process for a clean minimal install base.
# Reference screenshot: https://i.e33.io/screenshots/deb-minimal-install.jpg
# ---------------------------------------------------------------------------
# Instructions for running this script:
#   sudo apt install git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh deb-post-install-options.sh
# ===========================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

release="$(lsb_release -a | awk '/Codename:/ { print $2 }')"
if [ ! $release = trixie ]; then
    echo "################################################################"
    echo "Debian Initial Setup and WM or DE Installation is NOT"
    echo "compatible with your version of Linux, and it will exit now"
    echo "without running or making any changes."
    echo "################################################################"
    exit 1
fi

clear
echo "################################################################"
echo "Debian Initial Setup (read carefully)"
echo "################################################################"
echo "The initial setup option below does the following things:"
echo "  - Runs console-setup to set TTY font and font size"
echo "      Suggested selections:"
echo "        - UFT-8"
echo "        - Latin1 and Latin5 - western Europe and Turkic..."
echo "        - Terminus"
echo "        - 8x16 for non-HiDPI and VMs, or 16x32 for HiDPI"
echo "  - Updates Debian 13 Trixie apt sources.list file"
echo "  - Installs additional firmware packages"
echo "  - Makes and sets up a swap file (if one doesn't exist)"
echo "----------------------------------------------------------------"

while true; do
    read -p "Do you want to run the initial setup option? (y/n) " yn
    case $yn in
        [Yy]* ) echo "You chose to run the initial setup option";
                sh deb-post-install-setup.sh;
                break;;
        [Nn]* ) echo "You chose NOT to run the initial setup option";
                break;;
        * ) echo "Please answer y (for yes) or n (for no)";;
    esac
done

clear
echo "################################################################"
echo "Window Manager or Desktop Environment Installation"
echo "################################################################"
echo "The options below will install a selected window manager"
echo "or desktop environment and a base set of apps for a"
echo "ready-to-use desktop session."
echo "----------------------------------------------------------------"
echo "List of window managers and desktop environments:"
echo "  0) None, exit script now and install my own"
echo "  1) i3 Window Manager (tiling WM)"
echo "  2) JWM Window Manager (floating WM)"
echo "  3) Xfce Desktop Environment"
echo "  4) Gnome Desktop Environment"

while true; do
    read -p "Which window manager or desktop environment do you want to install? " n
    case $n in
        0) echo "You chose to exit the script and install your own";
           exit 1;;
        1) echo "You chose i3 Window Manager";
           sh deb-post-install-i3.sh;
           break;;
        2) echo "You chose JWM Window Manager";
           sh deb-post-install-jwm.sh;
           break;;
        3) echo "You chose Xfce Desktop Environment";
           sh deb-post-install-xfce.sh;
           break;;
        4) echo "You chose Gnome Desktop Environment";
           sh deb-post-install-gnome.sh;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done
