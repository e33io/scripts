#!/bin/bash

# =============================================================================
# Install Sovran Fonts - SovranMono, SovranSans, and SovranSerif
# URL: https://github.com/e33io/scripts/blob/main/install-sovran-fonts.sh
# =============================================================================

if ! command -v git > /dev/null 2>&1; then
    echo "========================================================================"
    echo "This script requires git. Install git and try again."
    echo "========================================================================"
    exit 1
fi

echo "========================================================================"
echo "Clone font files and make truetype directory"
echo "========================================================================"

git clone https://github.com/e33io/sovran-fonts ~/temp-fonts
sudo mkdir -p /usr/share/fonts/truetype

echo "========================================================================"
echo "Copy Sovran fonts to the truetype directory"
echo "========================================================================"

sudo cp -R ~/temp-fonts/SovranMono/SovranMono /usr/share/fonts/truetype
sudo cp -R ~/temp-fonts/SovranMono/SovranMono-Nerd /usr/share/fonts/truetype
sudo cp -R ~/temp-fonts/SovranMono/SovranMono-Nerd-Mono /usr/share/fonts/truetype
sudo cp -R ~/temp-fonts/SovranMono/SovranMono-Nerd-Propo /usr/share/fonts/truetype
sudo cp -R ~/temp-fonts/SovranSans/SovranSans /usr/share/fonts/truetype
sudo cp -R ~/temp-fonts/SovranSerif/SovranSerif /usr/share/fonts/truetype

echo "========================================================================"
echo "Clean up temp files and cache fonts"
echo "========================================================================"

rm -rf ~/temp-fonts
fc-cache -f

echo "========================================================================"
echo "Sovran fonts are now installed"
echo "========================================================================"
