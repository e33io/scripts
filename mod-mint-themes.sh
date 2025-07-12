#!/bin/bash

# ======================================================================
# Modify Linux Mint Dark themes for a slightly darker overall appearance
# URL: https://github.com/e33io/scripts/blob/main/mod-mint-themes.sh
# ----------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# ======================================================================

echo "################################################################"
echo "Update lighter gray theme colors to darker gray color"
echo "################################################################"

sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark-*/cinnamon/cinnamon.css
sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark-*/gtk-2.0/gtkrc
sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark-*/gtk-3.0/gtk*
sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark/cinnamon/cinnamon.css
sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark/gtk-2.0/gtkrc
sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark/gtk-3.0/gtk*
sudo sed -i 's/#404040/#1e1e1e/g' /usr/share/themes/Mint-*-Dark*/gtk-4.0/gtk*
sudo sed -i 's/background-color: rgba(103, 103, 103, 0\.4)/background-color: rgba(30, 30, 30, 1)/g' \
/usr/share/themes/Mint-*-Dark-*/gtk-3.0/gtk*
sudo sed -i 's/background-color: rgba(103, 103, 103, 0\.4)/background-color: rgba(30, 30, 30, 1)/g' \
/usr/share/themes/Mint-*-Dark/gtk-3.0/gtk*
sudo sed -i 's/background-color: rgba(103, 103, 103, 0\.4)/background-color: rgba(30, 30, 30, 1)/g' \
/usr/share/themes/Mint-*-Dark*/gtk-4.0/gtk*
sudo sed -i 's/background-color: rgba(99, 99, 99, 0\.4)/background-color: rgba(30, 30, 30, 1)/g' \
/usr/share/themes/Mint-*-Dark-*/gtk-3.0/gtk*
sudo sed -i 's/background-color: rgba(99, 99, 99, 0\.4)/background-color: rgba(30, 30, 30, 1)/g' \
/usr/share/themes/Mint-*-Dark/gtk-3.0/gtk*
sudo sed -i 's/background-color: rgba(99, 99, 99, 0\.4)/background-color: rgba(30, 30, 30, 1)/g' \
/usr/share/themes/Mint-*-Dark*/gtk-4.0/gtk*

echo "################################################################"
echo "Add custom CSS to update colors, borders and padding"
echo "################################################################"

echo '.primary-toolbar toolbar, .primary-toolbar .inline-toolbar,
.primary-toolbar:not(.libreoffice-toolbar) {
    background-color: @theme_bg_color;
    border-bottom: 1px solid @unfocused_borders;
    border-image: none;
}
toolbar.horizontal {
    padding-top: 5px;
}
entry {
    min-height: 1.7em;
}
.thunar entry {
    min-height: 0;
}
.thunar menubar spinner {
    min-width: 12px;
    min-height: 12px;
}
menubar, .menubar {
    background-color: @theme_bg_color;
}
menubar {
    border-bottom: 1px solid @unfocused_borders;
}
tooltip, #Tooltip {
    color: #ffffff;
    border-radius: 0;
    border: none;
    box-shadow: none;
}
tooltip.background, .tooltip.background, #Tooltip {
    background-color: #121212;
    background-clip: padding-box;
}
tooltip.background label, .tooltip.background label {
    padding: 4px;
}
tooltip decoration {
    background-color: transparent;
}
tooltip * {
    background-color: transparent;
    color: #ffffff;
}
#Tooltip {
    padding: 8px;
    margin: 3px;
}' | sudo tee -a /usr/share/themes/Mint-*-Dark-*/cinnamon/cinnamon.css \
                 /usr/share/themes/Mint-*-Dark-*/gtk-3.0/gtk* \
                 /usr/share/themes/Mint-*-Dark/cinnamon/cinnamon.css \
                 /usr/share/themes/Mint-*-Dark/gtk-3.0/gtk* \
                 /usr/share/themes/Mint-*-Dark*/gtk-4.0/gtk* > /dev/null

echo "################################################################"
echo "Logout or reboot the PC for changes to take effect"
echo "################################################################"
