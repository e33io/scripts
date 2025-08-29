#!/bin/bash

# =============================================================================
# Select and Set Theming for Xfce and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-xfce-theming.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian or Arch Linux!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "This script MUST NOT be run as root user."
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

if ! { [ -f "/etc/debian_version" ] || [ -f "/etc/pacman.conf" ]; }; then
    echo "========================================================================"
    echo "This script is NOT compatible with your version of Linux!"
    echo "It only works with Debian or Arch Linux and it will"
    echo "exit now without running."
    echo "========================================================================"
    exit 1
fi

# install dark-mod-themes if needed
if [ ! -n "$(ls -d /usr/share/themes/Mint-*-Dark-Mod-* 2>/dev/null)" ]; then
    git clone https://github.com/e33io/scripts $HOME/scripts-theming
    sh $HOME/scripts-theming/install-dark-mod-themes.sh
    rm -rf $HOME/scripts-theming
    printf "%s\n" "[Desktop Entry]" "Type=Application" "Version=1.0" "Name=Kvantum Manager" \
    "Comment=A simple GUI for Kvantum themes" "Exec=kvantummanager" "Icon=kvantum" "Terminal=false" \
    "Categories=Settings;DesktopSettings;LXQt;X-XFCE-SettingsDialog;X-XFCE-PersonalSettings;X-GNOME-PersonalSettings;" \
    "X-KDE-StartupNotify=false" > $HOME/.local/share/applications/kvantummanager.desktop
fi

# install yaru dark themes if needed
if [ ! -n "$(ls -d /usr/share/Kvantum/Yaru* 2>/dev/null)" ]; then
    git clone https://github.com/e33io/scripts $HOME/scripts-theming
    sh $HOME/scripts-theming/install-dark-yaru-themes.sh
    rm -rf $HOME/scripts-theming
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
    # Xfce docklike plugin config and color
    if [ -f $HOME/.config/xfce4/panel/docklike*.rc ]; then
        if ! grep -q ^indicatorStyle= $HOME/.config/xfce4/panel/docklike*.rc; then
            echo "indicatorStyle=0" \
            | tee -a $HOME/.config/xfce4/panel/docklike*.rc > /dev/null
        else
            sed -i "s/^indicatorStyle=.*/indicatorStyle=0/" \
            $HOME/.config/xfce4/panel/docklike*.rc
        fi
        if ! grep -q inactiveIndicatorStyle= $HOME/.config/xfce4/panel/docklike*.rc; then
            echo "inactiveIndicatorStyle=2" \
            | tee -a $HOME/.config/xfce4/panel/docklike*.rc > /dev/null
        else
            sed -i "s/inactiveIndicatorStyle=.*/inactiveIndicatorStyle=2/" \
            $HOME/.config/xfce4/panel/docklike*.rc
        fi
        if ! grep -q indicatorColorFromTheme= $HOME/.config/xfce4/panel/docklike*.rc; then
            echo "indicatorColorFromTheme=false" \
            | tee -a $HOME/.config/xfce4/panel/docklike*.rc > /dev/null
        else
            sed -i "s/indicatorColorFromTheme=true/indicatorColorFromTheme=false/" \
            $HOME/.config/xfce4/panel/docklike*.rc
        fi
        if ! grep -q indicatorColor= $HOME/.config/xfce4/panel/docklike*.rc; then
            echo "indicatorColor=$accent_color_rgb" \
            | tee -a $HOME/.config/xfce4/panel/docklike*.rc > /dev/null
        else
            sed -i "s/indicatorColor=.*/indicatorColor=$accent_color_rgb/" \
            $HOME/.config/xfce4/panel/docklike*.rc
        fi
        if ! grep -q inactiveColor= $HOME/.config/xfce4/panel/docklike*.rc; then
            echo "inactiveColor=$accent_color_rgb" \
            | tee -a $HOME/.config/xfce4/panel/docklike*.rc > /dev/null
        else
            sed -i "s/inactiveColor=.*/inactiveColor=$accent_color_rgb/" \
            $HOME/.config/xfce4/panel/docklike*.rc
        fi
    fi
    # Qt5ct theme and icon theme
    sed -i "s/^style=.*/style=$qt_ct_theme/" $HOME/.config/qt5ct/qt5ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" $HOME/.config/qt5ct/qt5ct.conf
    # Qt6ct theme and icon theme
    sed -i "s/^style=.*/style=$qt_ct_theme/" $HOME/.config/qt6ct/qt6ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" $HOME/.config/qt6ct/qt6ct.conf
    # Kvantum theme
    printf "[General]\ntheme=" | tee $HOME/.config/Kvantum/kvantum.kvconfig > /dev/null
    sed -i "s/theme=.*/theme=$kvantum_theme/" $HOME/.config/Kvantum/kvantum.kvconfig
    # Lightdm background color, GTK theme and icon theme
    sudo sed -i "s/^background =.*/background = $desktop_bg_color/" /etc/lightdm/lightdm-gtk-greeter.conf
    sudo sed -i "s/^icon-theme-name =.*/icon-theme-name = $icon_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
    sudo sed -i "s/^theme-name =.*/theme-name = $gtk_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
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
    accent_color_rgb="rgb(21,83,158)"
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
    accent_color_rgb="rgb(53,132,228)"
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
    accent_color_rgb="rgb(156,126,101)"
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
    accent_color_rgb="rgb(87,156,142)"
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
    accent_color_rgb="rgb(12,117,222)"
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
    accent_color_rgb="rgb(53,168,84)"
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
    accent_color_rgb="rgb(142,145,151)"
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
    papirus_folders=darkcyan
    # Desktop background color
    desktop_bg_color="#352620"
    # Theme accent color
    accent_color="#ff7139"
    accent_color_rgb="rgb(255,113,57)"
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
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#2e253e"
    # Theme accent color
    accent_color="#8c5dd9"
    accent_color_rgb="rgb(140,93,217)"
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
    accent_color_rgb="rgb(232,33,39)"
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
    accent_color_rgb="rgb(25,156,168)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Yaru_Blue_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-blue-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-blue-dark
    icon_theme=Papirus-Dark
    papirus_folders=blue
    # Desktop background color
    desktop_bg_color="#202b35"
    # Theme accent color
    accent_color="#0073e5"
    accent_color_rgb="rgb(0,115,229)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Yaru_Green_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-viridian-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-viridian-dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#1b2d27"
    # Theme accent color
    accent_color="#03875b"
    accent_color_rgb="rgb(3,135,91)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Yaru_Orange_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-orange-dark
    icon_theme=Papirus-Dark
    papirus_folders=yaru
    # Desktop background color
    desktop_bg_color="#362620"
    # Theme accent color
    accent_color="#e95420"
    accent_color_rgb="rgb(233,84,32)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Yaru_Purple_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-purple-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-purple-dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#2b2640"
    # Theme accent color
    accent_color="#7764d8"
    accent_color_rgb="rgb(119,100,216)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Yaru_Sage_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-sage-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-sage-dark
    icon_theme=Papirus-Dark
    papirus_folders=paleorange
    # Desktop background color
    desktop_bg_color="#232b25"
    # Theme accent color
    accent_color="#657b69"
    accent_color_rgb="rgb(101,123,105)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

Yaru_Teal_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-prussiangreen-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-prussiangreen-dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#1b2d2d"
    # Theme accent color
    accent_color="#308280"
    accent_color_rgb="rgb(48,130,128)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
}

while true; do
    echo "========================================================================"
    echo "Select and set theming for Xfce and applications"
    echo "========================================================================"
    echo ""
    printf "   0) Keep current theming\n"
    printf "   1) Adwaita-Dark         \e[38;5;236m▇▇▇\e[0m\e[38;5;025m▇▇▇\e[0m\n"
    printf "   2) Adwaita-Light        \e[38;5;255m▇▇▇\e[0m\e[38;5;032m▇▇▇\e[0m\n"
    printf "   3) Mint-L-Dark-Brown    \e[38;5;237m▇▇▇\e[0m\e[38;5;137m▇▇▇\e[0m\n"
    printf "   4) Mint-L-Dark-Teal     \e[38;5;237m▇▇▇\e[0m\e[38;5;066m▇▇▇\e[0m\n"
    printf "   5) Mint-Y-Dark-Blue     \e[38;5;237m▇▇▇\e[0m\e[38;5;033m▇▇▇\e[0m\n"
    printf "   6) Mint-Y-Dark-Green    \e[38;5;237m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   7) Mint-Y-Dark-Grey     \e[38;5;237m▇▇▇\e[0m\e[38;5;243m▇▇▇\e[0m\n"
    printf "   8) Mint-Y-Dark-Orange   \e[38;5;237m▇▇▇\e[0m\e[38;5;208m▇▇▇\e[0m\n"
    printf "   9) Mint-Y-Dark-Purple   \e[38;5;237m▇▇▇\e[0m\e[38;5;098m▇▇▇\e[0m\n"
    printf "  10) Mint-Y-Dark-Red      \e[38;5;237m▇▇▇\e[0m\e[38;5;160m▇▇▇\e[0m\n"
    printf "  11) Mint-Y-Dark-Teal     \e[38;5;237m▇▇▇\e[0m\e[38;5;037m▇▇▇\e[0m\n"
    printf "  12) Yaru-Blue-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;027m▇▇▇\e[0m\n"
    printf "  13) Yaru-Green-Dark      \e[38;5;236m▇▇▇\e[0m\e[38;5;029m▇▇▇\e[0m\n"
    printf "  14) Yaru-Orange-Dark     \e[38;5;236m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  15) Yaru-Purple-Dark     \e[38;5;236m▇▇▇\e[0m\e[38;5;099m▇▇▇\e[0m\n"
    printf "  16) Yaru-Sage-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;065m▇▇▇\e[0m\n"
    printf "  17) Yaru-Teal-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;030m▇▇▇\e[0m\n"
    echo ""

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
        12) echo "You chose Yaru-Blue-Dark";
           Yaru_Blue_Dark;
           break;;
        13) echo "You chose Yaru-Green-Dark";
           Yaru_Green_Dark;
           break;;
        14) echo "You chose Yaru-Orange-Dark";
           Yaru_Orange_Dark;
           break;;
        15) echo "You chose Yaru-Purple-Dark";
           Yaru_Purple_Dark;
           break;;
        16) echo "You chose Yaru-Sage-Dark";
           Yaru_Sage_Dark;
           break;;
        17) echo "You chose Yaru-Teal-Dark";
           Yaru_Teal_Dark;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "========================================================================"
echo "Reboot the system or logout/login now to complete changes"
echo "========================================================================"
