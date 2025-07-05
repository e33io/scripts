#!/bin/bash

# ===================================================================
# Select and Set Theming for Xfce and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-xfce-theming.sh
# -------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian or Arch Linux!
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
    printf "%s\n" "[Desktop Entry]" "Type=Application" "Version=1.0" "Name=Kvantum Manager" \
    "Comment=A simple GUI for Kvantum themes" "Exec=kvantummanager" "Icon=kvantum" "Terminal=false" \
    "Categories=Qt;Settings;DesktopSettings;LXQt;X-XFCE-SettingsDialog;X-XFCE-PersonalSettings;X-GNOME-PersonalSettings;" \
    "X-KDE-StartupNotify=false" > $HOME/.local/share/applications/kvantummanager.desktop
fi

# install papirus-icon-theme and papirus-folders if needed
if [ ! -n "$(ls -d /usr/bin/papirus-folders 2>/dev/null)" ]; then
    if [ -f "/etc/debian_version" ]; then
        sudo apt -y install papirus-icon-theme
    fi
    if [ -f "/etc/pacman.conf" ]; then
        sudo pacman -S --noconfirm --needed papirus-icon-theme
    fi
    wget -qO- https://git.io/papirus-folders-install | sh
fi

clear

theming_files () {
    # Xfce GTK theme and icon theme
    sed -i "s/\"ThemeName\" type=\"string\" value=\".*\"/\"ThemeName\" type=\"string\" value=\"$gtk_theme\"/" \
    $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
    sed -i "s/\"IconThemeName\" type=\"string\" value=\".*\"/\"IconThemeName\" type=\"string\" value=\"$icon_theme\"/" \
    $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
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
    # Lightdm background color, GTK theme and icon theme
    if [ -f "/etc/lightdm/lightdm-gtk-greeter.conf" ]; then
        sudo sed -i "s/^background =.*/background = $desktop_bg_color/" /etc/lightdm/lightdm-gtk-greeter.conf
        sudo sed -i "s/^icon-theme-name =.*/icon-theme-name = $icon_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
        sudo sed -i "s/^theme-name =.*/theme-name = $gtk_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
    fi
    # CAVA foreground color
    if [ -f "$HOME/.config/cava/config" ]; then
        sed -i "s/^foreground = .*/foreground = '$accent_color'/" $HOME/.config/cava/config
    fi
    # Papirus folders color
    if [ -f "/usr/bin/papirus-folders" ]; then
        papirus-folders -C $papirus_folders --theme $icon_theme
    fi
    # Reload Xfce xfdesktop settings
    xfdesktop --reload
}

Adwaita_Dark () {
    # GUI and TUI theme names
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Desktop background color
    desktop_bg_color="#202a36"
    # Theme accent color
    accent_color="#15539e"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Adwaita_Light () {
    # GUI and TUI theme names
    gtk_theme=Adwaita
    qt_ct_theme=Adwaita
    icon_theme=Papirus-Light
    papirus_folders=blue
    # Desktop background color
    desktop_bg_color="#303e50"
    # Theme accent color
    accent_color="#3584e4"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
}

Mint_L_Dark_Mod_Brown () {
    # GUI and TUI theme names
    gtk_theme=Mint-L-Dark-Mod-Brown
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Brown
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Desktop background color
    desktop_bg_color="#32271e"
    # Theme accent color
    accent_color="#9c7e65"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_L_Dark_Mod_Teal () {
    # GUI and TUI theme names
    gtk_theme=Mint-L-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#1b2d29"
    # Theme accent color
    accent_color="#579c8e"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Blue () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Blue
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Blue
    icon_theme=Papirus-Dark
    papirus_folders=blue
    # Desktop background color
    desktop_bg_color="#202a35"
    # Theme accent color
    accent_color="#0c75de"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Green () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Green
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Green
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#1b2d20"
    # Theme accent color
    accent_color="#35a854"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Grey () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Grey
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Grey
    icon_theme=Papirus-Dark
    papirus_folders=white
    # Desktop background color
    desktop_bg_color="#282a2c"
    # Theme accent color
    accent_color="#8e9197"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Orange () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Orange
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Orange
    icon_theme=Papirus-Dark
    papirus_folders=paleorange
    # Desktop background color
    desktop_bg_color="#352620"
    # Theme accent color
    accent_color="#ff7139"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Purple () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Purple
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Purple
    icon_theme=Papirus-Dark
    papirus_folders=green
    # Desktop background color
    desktop_bg_color="#2e253e"
    # Theme accent color
    accent_color="#8c5dd9"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Red () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Red
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Red
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Desktop background color
    desktop_bg_color="#3b2324"
    # Theme accent color
    accent_color="#e82127"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Mint_Y_Dark_Mod_Teal () {
    # GUI and TUI theme names
    gtk_theme=Mint-Y-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#1b2c2e"
    # Theme accent color
    accent_color="#199ca8"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

while true; do
    echo "################################################################"
    echo "Select and set theming for Xfce and applications"
    echo "################################################################"
    echo "List of available themes:"
    echo "   0) Keep current theming"
    echo "   1) Adwaita-Dark"
    echo "   2) Adwaita-Light"
    echo "   3) Mint-L-Dark-Mod-Brown"
    echo "   4) Mint-L-Dark-Mod-Teal"
    echo "   5) Mint-Y-Dark-Mod-Blue"
    echo "   6) Mint-Y-Dark-Mod-Green"
    echo "   7) Mint-Y-Dark-Mod-Grey"
    echo "   8) Mint-Y-Dark-Mod-Orange"
    echo "   9) Mint-Y-Dark-Mod-Purple"
    echo "  10) Mint-Y-Dark-Mod-Red"
    echo "  11) Mint-Y-Dark-Mod-Teal"

    read -p "Which theme do you want to use? " n
    case $n in
        0) echo "You chose to keep current theming";
           exit 1;;
        1) echo "You chose Adwaita-Dark";
           Adwaita_Dark;
           break;;
        2) echo "You chose Adwaita-Light";
           Adwaita_Light;
           break;;
        3) echo "You chose Mint-L-Dark-Mod-Brown";
           Mint_L_Dark_Mod_Brown;
           break;;
        4) echo "You chose Mint-L-Dark-Mod-Teal";
           Mint_L_Dark_Mod_Teal;
           break;;
        5) echo "You chose Mint-Y-Dark-Mod-Blue";
           Mint_Y_Dark_Mod_Blue;
           break;;
        6) echo "You chose Mint-Y-Dark-Mod-Green";
           Mint_Y_Dark_Mod_Green;
           break;;
        7) echo "You chose Mint-Y-Dark-Mod-Grey";
           Mint_Y_Dark_Mod_Grey;
           break;;
        8) echo "You chose Mint-Y-Dark-Mod-Orange";
           Mint_Y_Dark_Mod_Orange;
           break;;
        9) echo "You chose Mint-Y-Dark-Mod-Purple";
           Mint_Y_Dark_Mod_Purple;
           break;;
        10) echo "You chose Mint-Y-Dark-Mod-Red";
           Mint_Y_Dark_Mod_Red;
           break;;
        11) echo "You chose Mint-Y-Dark-Mod-Teal";
           Mint_Y_Dark_Mod_Teal;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "################################################################"
echo "Reboot the system or logout/login now to complete changes"
echo "################################################################"
