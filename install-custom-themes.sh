#!/bin/bash

# =============================================================================
# Install Custom Mint and Yaru Themes on Arch Linux
# URL: https://github.com/e33io/scripts/blob/main/install-custom-themes.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "Do not run as root. Run as a normal user with sudo privileges."
    echo "========================================================================"
    exit 1
fi

echo "========================================================================"
echo "Install theming dependencies"
echo "========================================================================"

if ! command -v yay > /dev/null 2>&1; then
    echo "========================================================================"
    echo "Setup Yay for AUR"
    echo "========================================================================"

    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    (cd ~/yay-bin && makepkg -si --noconfirm)
    rm -rf ~/yay-bin
fi
sudo pacman -Syu --noconfirm --needed gnome-themes-extra kvantum kvantum-qt5 \
papirus-icon-theme less git
yay -S --noconfirm --needed --sudoloop adwaita-qt5 adwaita-qt6

if ! command -v lxqt-session > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed qt5ct qt6ct
fi

echo "========================================================================"
echo "Clone custom theming repo"
echo "========================================================================"

git clone https://github.com/e33io/theming ~/theming-temp

echo "========================================================================"
echo "Copy custom Mint themes"
echo "========================================================================"

sudo cp -R ~/theming-temp/gtk/Mint* /usr/share/themes
sudo mkdir -p /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Mint* /usr/share/Kvantum

echo "========================================================================"
echo "Copy custom Yaru themes"
echo "========================================================================"

sudo cp -R ~/theming-temp/gtk/Yaru* /usr/share/themes
# copy only selected Kvantum theme variants
sudo cp -R ~/theming-temp/Kvantum/Yaru-blue-dark /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-orange /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-orange-dark /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-prussiangreen-dark /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-purple-dark /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-sage-dark /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-viridian-dark /usr/share/Kvantum
sudo cp -R ~/theming-temp/Kvantum/Yaru-wartybrown-dark /usr/share/Kvantum

echo "========================================================================"
echo "Link config files to root user directories for styling"
echo "su/root applications"
echo "========================================================================"

sudo mkdir -p /root/.config

if command -v lxappearance > /dev/null 2>&1; then
    if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
        mkdir -p ~/.config/gtk-3.0
        touch ~/.config/gtk-3.0/settings.ini
    fi
    if [ ! -f ~/.gtkrc-2.0 ]; then
        touch ~/.gtkrc-2.0
    fi
    sudo mkdir -p /root/.config/gtk-3.0
    sudo ln -sf ~/.config/gtk-3.0/* /root/.config/gtk-3.0
    sudo ln -sf ~/.gtkrc-2.0 /root/.gtkrc-2.0
fi

if command -v kvantummanager > /dev/null 2>&1; then
    if [ ! -f ~/.config/Kvantum/kvantum.kvconfig ]; then
        mkdir -p ~/.config/Kvantum
        touch ~/.config/Kvantum/kvantum.kvconfig
    fi
    sudo mkdir -p /root/.config/Kvantum
    sudo ln -sf ~/.config/Kvantum/* /root/.config/Kvantum
fi

if command -v qt5ct > /dev/null 2>&1; then
    if [ ! -f ~/.config/qt5ct/qt5ct.conf ]; then
        mkdir -p ~/.config/qt5ct
        touch ~/.config/qt5ct/qt5ct.conf
    fi
    sudo mkdir -p /root/.config/qt5ct
    sudo ln -sf ~/.config/qt5ct/* /root/.config/qt5ct
fi

if command -v qt6ct > /dev/null 2>&1; then
    if [ ! -f ~/.config/qt6ct/qt6ct.conf ]; then
        mkdir -p ~/.config/qt6ct
        touch ~/.config/qt6ct/qt6ct.conf
    fi
    sudo mkdir -p /root/.config/qt6ct
    sudo ln -sf ~/.config/qt6ct/* /root/.config/qt6ct
fi

if ! command -v papirus-folders > /dev/null 2>&1; then
    wget -qO- https://git.io/papirus-folders-install | sh
fi

echo "========================================================================"
echo "Clean up directories"
echo "========================================================================"

echo "Custom themes installed via e33io script: $(date '+%B %d, %Y, %H:%M')" \
| tee -a ~/.install-info > /dev/null
rm -rf ~/theming-temp

echo "========================================================================"
echo "All done, custom themes are now installed"
echo "========================================================================"
