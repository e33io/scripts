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

git clone https://github.com/e33io/sovran-fonts ~/sovran-fonts
sudo mkdir -p /usr/share/fonts/truetype

echo "========================================================================"
echo "Copy Sovran fonts to the truetype directory"
echo "========================================================================"

sudo cp -R ~/sovran-fonts/SovranMono/SovranMono /usr/share/fonts/truetype
sudo cp -R ~/sovran-fonts/SovranMono/SovranMono-Nerd* /usr/share/fonts/truetype
sudo cp -R ~/sovran-fonts/SovranSans/SovranSans /usr/share/fonts/truetype
sudo cp -R ~/sovran-fonts/SovranSerif/SovranSerif /usr/share/fonts/truetype

echo "========================================================================"
echo "Clean up files and cache fonts"
echo "========================================================================"

rm -rf ~/sovran-fonts
fc-cache -f

echo "========================================================================"
echo "Sovran fonts are now installed"
echo "========================================================================"
