#!/bin/bash

# ===================================================================
# Select and Set Theming for JWM and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-jwm-theming.sh
# -------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian Linux!
# ===================================================================

if [ "$(id -u)" = 0 ]; then
    echo "################################################################"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "################################################################"
    exit 1
fi

if ! { [ -f "/etc/debian_version" ] || [ -f "/etc/pacman.conf" ]; }; then
    echo "################################################################"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Debian or Arch Linux and it will"
    echo "exit now without running."
    echo "################################################################"
    exit 1
fi

# install mint themes if needed
if [ ! -n "$(ls -d /usr/share/themes/Mint-*-Dark-Mod-* 2>/dev/null)" ]; then
    git clone https://github.com/e33io/scripts $HOME/scripts-theming
    if [ -f "/etc/debian_version" ]; then
        sh $HOME/scripts-theming/install-mint-themes.sh
    fi
    if [ -f "/etc/pacman.conf" ]; then
        sh $HOME/scripts-theming/install-mint-themes-arch.sh
    fi
    sudo rm -R $HOME/scripts-theming
fi

# install papirus-icon-theme and papirus-folders if needed
if [ ! -n "$(ls -d /usr/bin/papirus-folders 2>/dev/null)" ]; then
    if [ -f "/etc/debian_version" ]; then
        sudo apt -y install papirus-icon-theme
    fi
    if [ -f "/etc/pacman.conf" ]; then
        sudo pacman -S papirus-icon-theme
    fi
    wget -qO- https://git.io/papirus-folders-install | sh
fi

clear

theming_files () {
    # JWM theme
    sed -i "s/jwm\/themes\/.*<\/Include>/jwm\/themes\/$jwm_theme<\/Include>/" $HOME/.config/jwm/jwmrc
    # GTK 2 theme and icon theme
    sed -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$gtk_theme\"/" $HOME/.gtkrc-2.0
    sed -i "s/gtk-icon-theme-name=\".*\"/gtk-icon-theme-name=\"$icon_theme\"/" $HOME/.gtkrc-2.0
    # GTK 3 theme and icon theme
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" $HOME/.config/gtk-3.0/settings.ini
    sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/" $HOME/.config/gtk-3.0/settings.ini
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$prefer_dark_theme/" $HOME/.config/gtk-3.0/settings.ini
    # Qt5ct theme and icon theme
    sed -i "s/^style=.*/style=$qt_ct_theme/" $HOME/.config/qt5ct/qt5ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" $HOME/.config/qt5ct/qt5ct.conf
    # Qt6ct theme and icon theme
    sed -i "s/^style=.*/style=$qt_ct_theme/" $HOME/.config/qt6ct/qt6ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" $HOME/.config/qt6ct/qt6ct.conf
    # Kvantum theme
    if [ ! -f "$HOME/.config/Kvantum" ]; then
        mkdir -p $HOME/.config/Kvantum
        printf "[General]\ntheme=" | tee $HOME/.config/Kvantum/kvantum.kvconfig > /dev/null
    fi
    sed -i "s/theme=.*/theme=$kvantum_theme/" $HOME/.config/Kvantum/kvantum.kvconfig
    # Rofi theme and icon theme
    sed -i "s/rofi\/themes\/.*\"/rofi\/themes\/$rofi_theme\.rasi\"/" $HOME/.config/rofi/config.rasi
    sed -i "s/icon-theme: \".*\"/icon-theme: \"$icon_theme\"/" $HOME/.config/rofi/config.rasi
    # Desktop background color (only visible if no wallpaper is set)
    sed -i "s/xsetroot -solid \".*\"/xsetroot -solid \"$desktop_bg_color\"/" $HOME/.profile
    # Nitrogen desktop background color (visible if semi-transparent wallpaper is set)
    if [ -f "$HOME/.config/nitrogen/bg-saved.cfg" ]; then
        sed -i "s/bgcolor=.*/bgcolor=$desktop_bg_color/" $HOME/.config/nitrogen/bg-saved.cfg
    fi
    # CAVA foreground color
    if [ -f "$HOME/.config/cava/config" ]; then
        sed -i "s/^foreground = .*/foreground = '$cava_fg_color'/" $HOME/.config/cava/config
    fi
    # Papirus folders color
    if [ -f "/usr/bin/papirus-folders" ]; then
        papirus-folders -C $papirus_folders --theme Papirus-Dark
    fi
}

Adwaita_Dark () {
    # JWM theme
    jwm_theme="JWM-Adwaita-Dark"
    # CAVA foreground color
    cava_fg_color="#1c6dcf"
    # Desktop background color
    desktop_bg_color="#202a36"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    rofi_theme=Floating-Adwaita-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Adwaita_Darker () {
    # JWM theme
    jwm_theme="JWM-Adwaita-Darker"
    # CAVA foreground color
    cava_fg_color="#15539e"
    # Desktop background color
    desktop_bg_color="#202a36"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    rofi_theme=Floating-Adwaita-Darker
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Adwaita_Light () {
    # JWM theme
    jwm_theme="JWM-Adwaita-Light"
    # CAVA foreground color
    cava_fg_color="#3584e4"
    # Desktop background color
    desktop_bg_color="#303e50"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Adwaita
    qt_ct_theme=Adwaita
    rofi_theme=Floating-Adwaita-Light
    icon_theme=Papirus-Light
    papirus_folders=blue
    # Call the theming files
    theming_files
}

Mint_L_Dark_Mod_Brown () {
    # JWM theme
    jwm_theme="JWM-Mint-L-Dark-Brown"
    # CAVA foreground color
    cava_fg_color="#9c7e65"
    # Desktop background color
    desktop_bg_color="#32271e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-L-Dark-Mod-Brown
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Brown
    rofi_theme=Floating-Mint-L-Dark-Brown
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_L_Dark_Mod_Teal () {
    # JWM theme
    jwm_theme="JWM-Mint-L-Dark-Teal"
    # CAVA foreground color
    cava_fg_color="#579c8e"
    # Desktop background color
    desktop_bg_color="#1b2d29"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-L-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Teal
    rofi_theme=Floating-Mint-L-Dark-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Blue () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Blue"
    # CAVA foreground color
    cava_fg_color="#0c75de"
    # Desktop background color
    desktop_bg_color="#202a35"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Blue
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Blue
    rofi_theme=Floating-Mint-Y-Dark-Blue
    icon_theme=Papirus-Dark
    papirus_folders=blue
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Green () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Green"
    # CAVA foreground color
    cava_fg_color="#35a854"
    # Desktop background color
    desktop_bg_color="#1b2d20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Green
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Green
    rofi_theme=Floating-Mint-Y-Dark-Green
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Grey () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Grey"
    # CAVA foreground color
    cava_fg_color="#8e9197"
    # Desktop background color
    desktop_bg_color="#282a2c"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Grey
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Grey
    rofi_theme=Floating-Mint-Y-Dark-Grey
    icon_theme=Papirus-Dark
    papirus_folders=white
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Orange () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Orange"
    # CAVA foreground color
    cava_fg_color="#ff7139"
    # Desktop background color
    desktop_bg_color="#352620"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Orange
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Orange
    rofi_theme=Floating-Mint-Y-Dark-Orange
    icon_theme=Papirus-Dark
    papirus_folders=paleorange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Purple () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Purple"
    # CAVA foreground color
    cava_fg_color="#8c5dd9"
    # Desktop background color
    desktop_bg_color="#2e253e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Purple
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Purple
    rofi_theme=Floating-Mint-Y-Dark-Purple
    icon_theme=Papirus-Dark
    papirus_folders=green
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Red () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Red"
    # CAVA foreground color
    cava_fg_color="#e82127"
    # Desktop background color
    desktop_bg_color="#3b2324"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Red
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Red
    rofi_theme=Floating-Mint-Y-Dark-Red
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Teal () {
    # JWM theme
    jwm_theme="JWM-Mint-Y-Dark-Teal"
    # CAVA foreground color
    cava_fg_color="#199ca8"
    # Desktop background color
    desktop_bg_color="#1b2c2e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Teal
    rofi_theme=Floating-Mint-Y-Dark-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

while true; do
    echo "################################################################"
    echo "Select and set theming for JWM and applications"
    echo "################################################################"
    echo "List of available themes:"
    echo "   0) Keep current theming"
    echo "   1) Adwaita-Dark"
    echo "   2) Adwaita-Darker"
    echo "   3) Adwaita-Light"
    echo "   4) Mint-L-Dark-Mod-Brown"
    echo "   5) Mint-L-Dark-Mod-Teal"
    echo "   6) Mint-Y-Dark-Mod-Blue"
    echo "   7) Mint-Y-Dark-Mod-Green"
    echo "   8) Mint-Y-Dark-Mod-Grey"
    echo "   9) Mint-Y-Dark-Mod-Orange"
    echo "  10) Mint-Y-Dark-Mod-Purple"
    echo "  11) Mint-Y-Dark-Mod-Red"
    echo "  12) Mint-Y-Dark-Mod-Teal"

    read -p "Which theme do you want to use? " n
    case $n in
        0) echo "You chose to keep current theming";
           exit 1;;
        1) echo "You chose Adwaita-Dark";
           Adwaita_Dark;
           break;;
        2) echo "You chose Adwaita-Darker";
           Adwaita_Darker;
           break;;
        3) echo "You chose Adwaita-Light";
           Adwaita_Light;
           break;;
        4) echo "You chose Mint-L-Dark-Mod-Brown";
           Mint_L_Dark_Mod_Brown;
           break;;
        5) echo "You chose Mint-L-Dark-Mod-Teal";
           Mint_L_Dark_Mod_Teal;
           break;;
        6) echo "You chose Mint-Y-Dark-Mod-Blue";
           Mint_Y_Dark_Mod_Blue;
           break;;
        7) echo "You chose Mint-Y-Dark-Mod-Green";
           Mint_Y_Dark_Mod_Green;
           break;;
        8) echo "You chose Mint-Y-Dark-Mod-Grey";
           Mint_Y_Dark_Mod_Grey;
           break;;
        9) echo "You chose Mint-Y-Dark-Mod-Orange";
           Mint_Y_Dark_Mod_Orange;
           break;;
        10) echo "You chose Mint-Y-Dark-Mod-Purple";
           Mint_Y_Dark_Mod_Purple;
           break;;
        11) echo "You chose Mint-Y-Dark-Mod-Red";
           Mint_Y_Dark_Mod_Red;
           break;;
        12) echo "You chose Mint-Y-Dark-Mod-Teal";
           Mint_Y_Dark_Mod_Teal;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "################################################################"
echo "Reboot the system or logout/login now to complete changes"
echo "################################################################"
