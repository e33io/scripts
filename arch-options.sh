#!/bin/bash

# ======================================================================
# Arch Options for WM or DE Installation
# URL: https://github.com/e33io/scripts/blob/main/arch-options.sh
# ----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# Only use with a fresh "Minimal" archinstall (Profile > Type > Minimal)
# to select and install i3, JWM, Xfce or Gnome plus a base set of apps
# for a ready-to-use desktop session.
# ----------------------------------------------------------------------
# Instructions for running this script:
#   sudo pacman -Syu
#   sudo pacman -S git
#   git clone https://github.com/e33io/scripts
#   cd scripts
#   sh arch-options.sh
# ======================================================================

if [ "$(id -u)" = 0 ]; then
    echo "======================================================================="
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "======================================================================="
    exit 1
fi

clear

echo "======================================================================="
echo "Window Manager or Desktop Environment Installation"
echo "======================================================================="
echo "The options below will install a selected window manager"
echo "or desktop environment and a base set of apps for a"
echo "ready-to-use desktop session."
echo "-----------------------------------------------------------------------"
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
           sh $HOME/scripts/arch-install-i3.sh;
           break;;
        2) echo "You chose JWM Window Manager";
           sh $HOME/scripts/arch-install-jwm.sh;
           break;;
        3) echo "You chose Xfce Desktop Environment";
           sh $HOME/scripts/arch-install-xfce.sh;
           break;;
        4) echo "You chose Gnome Desktop Environment";
           sh $HOME/scripts/arch-install-gnome.sh;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done
