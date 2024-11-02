#!/bin/bash

# ==========================================================================
# Install Plex Fonts - PlexMonoMod, PlexSansMod, and PlexSerifMod
# URL: https://git.sr.ht/~e33io/scripts/tree/main/item/install-plex-fonts.sh
# ==========================================================================

echo "#########################################################"
echo "Clone font files and make truetype directory"
echo "#########################################################"

git clone https://git.sr.ht/~e33io/fonts $HOME/temp-fonts
sudo mkdir -p /usr/share/fonts/truetype

echo "#########################################################"
echo "Copy Plex fonts to the truetype directory"
echo "#########################################################"

sudo cp -R $HOME/temp-fonts/PlexMonoMod/PlexMonoMod /usr/share/fonts/truetype
sudo cp -R $HOME/temp-fonts/PlexMonoMod/PlexMonoMod-Nerd /usr/share/fonts/truetype
sudo cp -R $HOME/temp-fonts/PlexMonoMod/PlexMonoMod-Nerd-Mono /usr/share/fonts/truetype
sudo cp -R $HOME/temp-fonts/PlexMonoMod/PlexMonoMod-Nerd-Propo /usr/share/fonts/truetype
sudo cp -R $HOME/temp-fonts/PlexSansMod/PlexSansMod /usr/share/fonts/truetype
sudo cp -R $HOME/temp-fonts/PlexSerifMod/PlexSerifMod /usr/share/fonts/truetype

echo "#########################################################"
echo "Clean up temp files and cache fonts"
echo "#########################################################"

sudo rm -Rf $HOME/temp-fonts
fc-cache -f

echo "#########################################################"
echo "Plex fonts are now installed"
echo "#########################################################"
