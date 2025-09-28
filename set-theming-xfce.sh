#!/bin/bash

# =============================================================================
# Select and Set Theming for Xfce and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-theming-xfce.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with Debian or Arch Linux!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
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
    "Categories=Settings;DesktopSettings;X-XFCE-SettingsDialog;X-XFCE-PersonalSettings;X-GNOME-PersonalSettings;" \
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
    xfconf-query -c xsettings -p /Net/ThemeName -s "$gtk_theme"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "$icon_theme"
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
        papirus-folders -C $papirus_folders --theme $icon_theme > /dev/null
    fi
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
    papirus_folders=yellow
    # Desktop background color
    desktop_bg_color="#2d3b4c"
    # Theme accent color
    accent_color="#3584e4"
    accent_color_rgb="rgb(53,132,228)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
}

Mint_Blue_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Blue-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Blue-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
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

Mint_Green_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Green-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Green-Dark
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

Mint_Green_Light () {
    # GUI and TUI theme names
    gtk_theme=Mint-Green-Light
    qt_ct_theme=kvantum
    kvantum_theme=Mint-Green-Light
    icon_theme=Papirus-Light
    papirus_folders=orange
    # Desktop background color
    desktop_bg_color="#2f4e37"
    # Theme accent color
    accent_color="#35a854"
    accent_color_rgb="rgb(53,168,84)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
}

Mint_Grey_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Grey-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Grey-Dark
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

Mint_Orange_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Orange-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Orange-Dark
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

Mint_Purple_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Purple-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Purple-Dark
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

Mint_Red_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Red-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Red-Dark
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

Mint_Teal_Dark () {
    # GUI and TUI theme names
    gtk_theme=Mint-Teal-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Teal-Dark
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
    papirus_folders=adwaita
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

Yaru_Brown_Dark () {
    # GUI and TUI theme names
    gtk_theme=Yaru-wartybrown-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-wartybrown-dark
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Desktop background color
    desktop_bg_color="#32291e"
    # Theme accent color
    accent_color="#8c6c47"
    accent_color_rgb="rgb(140,108,71)"
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

Yaru_Orange_Light () {
    # GUI and TUI theme names
    gtk_theme=Yaru
    qt_ct_theme=kvantum
    kvantum_theme=Yaru-orange
    icon_theme=Papirus-Light
    papirus_folders=yaru
    # Desktop background color
    desktop_bg_color="#4e372f"
    # Theme accent color
    accent_color="#e95420"
    accent_color_rgb="rgb(233,84,32)"
    # Call the theming files
    theming_files
    # Dconf color-scheme preference
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
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
    echo
    printf "   0) Keep current theming\n"
    printf "   1) Adwaita-Dark        \e[38;5;236m▇▇▇\e[0m\e[38;5;025m▇▇▇\e[0m\n"
    printf "   2) Adwaita-Light       \e[38;5;255m▇▇▇\e[0m\e[38;5;032m▇▇▇\e[0m\n"
    printf "   3) Mint-Blue-Dark      \e[38;5;237m▇▇▇\e[0m\e[38;5;033m▇▇▇\e[0m\n"
    printf "   4) Mint-Green-Dark     \e[38;5;237m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   5) Mint-Green-Light    \e[38;5;255m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   6) Mint-Grey-Dark      \e[38;5;237m▇▇▇\e[0m\e[38;5;243m▇▇▇\e[0m\n"
    printf "   7) Mint-Orange-Dark    \e[38;5;237m▇▇▇\e[0m\e[38;5;208m▇▇▇\e[0m\n"
    printf "   8) Mint-Purple-Dark    \e[38;5;237m▇▇▇\e[0m\e[38;5;098m▇▇▇\e[0m\n"
    printf "   9) Mint-Red-Dark       \e[38;5;237m▇▇▇\e[0m\e[38;5;160m▇▇▇\e[0m\n"
    printf "  10) Mint-Teal-Dark      \e[38;5;237m▇▇▇\e[0m\e[38;5;037m▇▇▇\e[0m\n"
    printf "  11) Yaru-Blue-Dark      \e[38;5;236m▇▇▇\e[0m\e[38;5;027m▇▇▇\e[0m\n"
    printf "  12) Yaru-Brown-Dark     \e[38;5;236m▇▇▇\e[0m\e[38;5;094m▇▇▇\e[0m\n"
    printf "  13) Yaru-Green-Dark     \e[38;5;236m▇▇▇\e[0m\e[38;5;029m▇▇▇\e[0m\n"
    printf "  14) Yaru-Orange-Dark    \e[38;5;236m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  15) Yaru-Orange-Light   \e[38;5;255m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  16) Yaru-Purple-Dark    \e[38;5;236m▇▇▇\e[0m\e[38;5;099m▇▇▇\e[0m\n"
    printf "  17) Yaru-Sage-Dark      \e[38;5;236m▇▇▇\e[0m\e[38;5;065m▇▇▇\e[0m\n"
    printf "  18) Yaru-Teal-Dark      \e[38;5;236m▇▇▇\e[0m\e[38;5;030m▇▇▇\e[0m\n"
    echo

    read -p "Which theme do you want to use? " n
    case $n in
        0) echo "You chose to keep current theming";
           exit 1;;
        1) echo "You chose Adwaita-Dark, applying changes...";
           Adwaita_Dark;
           break;;
        2) echo "You chose Adwaita-Light, applying changes...";
           Adwaita_Light;
           break;;
        3) echo "You chose Mint-Blue-Dark, applying changes...";
           Mint_Blue_Dark;
           break;;
        4) echo "You chose Mint-Green-Dark, applying changes...";
           Mint_Green_Dark;
           break;;
        5) echo "You chose Mint-Green-Light, applying changes...";
           Mint_Green_Light;
           break;;
        6) echo "You chose Mint-Grey-Dark, applying changes...";
           Mint_Grey_Dark;
           break;;
        7) echo "You chose Mint-Orange-Dark, applying changes...";
           Mint_Orange_Dark;
           break;;
        8) echo "You chose Mint-Purple-Dark, applying changes...";
           Mint_Purple_Dark;
           break;;
        9) echo "You chose Mint-Red-Dark, applying changes...";
           Mint_Red_Dark;
           break;;
        10) echo "You chose Mint-Teal-Dark, applying changes...";
           Mint_Teal_Dark;
           break;;
        11) echo "You chose Yaru-Blue-Dark, applying changes...";
           Yaru_Blue_Dark;
           break;;
        12) echo "You chose Yaru-Brown-Dark, applying changes...";
           Yaru_Brown_Dark;
           break;;
        13) echo "You chose Yaru-Green-Dark, applying changes...";
           Yaru_Green_Dark;
           break;;
        14) echo "You chose Yaru-Orange-Dark, applying changes...";
           Yaru_Orange_Dark;
           break;;
        15) echo "You chose Yaru-Orange-Light, applying changes...";
           Yaru_Orange_Light;
           break;;
        16) echo "You chose Yaru-Purple-Dark, applying changes...";
           Yaru_Purple_Dark;
           break;;
        17) echo "You chose Yaru-Sage-Dark, applying changes...";
           Yaru_Sage_Dark;
           break;;
        18) echo "You chose Yaru-Teal-Dark, applying changes...";
           Yaru_Teal_Dark;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "========================================================================"
echo "Reboot the system or logout/login now to complete changes"
echo "========================================================================"
