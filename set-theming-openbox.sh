#!/bin/bash

# =============================================================================
# Select and Set Theming for Openbox and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-theming-openbox.sh
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
    # Openbox theme
    Xft_dpi=$(grep Xft.dpi ~/.Xresources | grep -Eo '[0-9]+')
    if [ $Xft_dpi -gt 96 ]; then
        sed -i "s/<name>Openbox-.*<\/name>/<name>Openbox-$openbox_theme-HiDPI<\/name>/" $HOME/.config/openbox/rc.xml
    else
        sed -i "s/<name>Openbox-.*<\/name>/<name>Openbox-$openbox_theme<\/name>/" $HOME/.config/openbox/rc.xml
    fi
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
    # GTK 2 theme and icon theme
    sed -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$gtk_theme\"/" $HOME/.gtkrc-2.0
    sed -i "s/gtk-icon-theme-name=\".*\"/gtk-icon-theme-name=\"$icon_theme\"/" $HOME/.gtkrc-2.0
    # GTK 3 theme and icon theme
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" $HOME/.config/gtk-3.0/settings.ini
    sed -i "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/" $HOME/.config/gtk-3.0/settings.ini
    sed -i "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$prefer_dark_theme/" \
    $HOME/.config/gtk-3.0/settings.ini
    # Qt5ct theme and icon theme
    sed -i "s/^style=.*/style=$qt_ct_theme/" $HOME/.config/qt5ct/qt5ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" $HOME/.config/qt5ct/qt5ct.conf
    # Qt6ct theme and icon theme
    sed -i "s/^style=.*/style=$qt_ct_theme/" $HOME/.config/qt6ct/qt6ct.conf
    sed -i "s/icon_theme=.*/icon_theme=$icon_theme/" $HOME/.config/qt6ct/qt6ct.conf
    # Kvantum theme
    printf "[General]\ntheme=" | tee $HOME/.config/Kvantum/kvantum.kvconfig > /dev/null
    sed -i "s/theme=.*/theme=$kvantum_theme/" $HOME/.config/Kvantum/kvantum.kvconfig
    # Rofi theme and icon theme
    if grep -q "Dmenu" $HOME/.config/rofi/config.rasi; then
        rofi_style=Dmenu
    elif grep -q "Floating" $HOME/.config/rofi/config.rasi; then
        rofi_style=Floating
    elif grep -q "Panel" $HOME/.config/rofi/config.rasi; then
        rofi_style=Panel
    fi
    sed -i "s/rofi\/themes\/.*\"/rofi\/themes\/$rofi_style-$rofi_theme\.rasi\"/" $HOME/.config/rofi/config.rasi
    sed -i "s/icon-theme: \".*\"/icon-theme: \"$icon_theme\"/" $HOME/.config/rofi/config.rasi
    # i3lock background color
    lock_bg_color=$(echo "$desktop_bg_color" | sed 's/^.//')
    sed -i "s/-n -c .* \&/-n -c $lock_bg_color \&/" $HOME/.config/openbox/autostart
    sed -i "s/-c .* \&/-c $lock_bg_color \&/" $HOME/.local/bin/lock-suspend.sh
    # XSecureLock background color
    sed -i "s/BACKGROUND_COLOR=\".*\"/BACKGROUND_COLOR=\"$desktop_bg_color\"/" $HOME/.profile
    # Lightdm background color, GTK 3 theme and icon theme
    sudo sed -i "s/^background =.*/background = $desktop_bg_color/" /etc/lightdm/lightdm-gtk-greeter.conf
    sudo sed -i "s/^icon-theme-name =.*/icon-theme-name = $icon_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
    sudo sed -i "s/^theme-name =.*/theme-name = $gtk_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
    # Nitrogen desktop background color (visible if semi-transparent wallpaper is set)
    if [ -f "$HOME/.config/nitrogen/bg-saved.cfg" ]; then
        sed -i "s/bgcolor=.*/bgcolor=$desktop_bg_color/" $HOME/.config/nitrogen/bg-saved.cfg
    fi
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
    # Openbox theme
    openbox_theme="Adwaita-Dark"
    # Theme accent color
    accent_color="#15539e"
    accent_color_rgb="rgb(21,83,158)"
    # Desktop background color
    desktop_bg_color="#202a36"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    rofi_theme=Adwaita-Darker
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Adwaita_Light () {
    # Openbox theme
    openbox_theme="Adwaita-Light"
    # Theme accent color
    accent_color="#3584e4"
    accent_color_rgb="rgb(53,132,228)"
    # Desktop background color
    desktop_bg_color="#2d3b4c"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Adwaita
    qt_ct_theme=Adwaita
    rofi_theme=Adwaita-Light
    icon_theme=Papirus-Light
    papirus_folders=yellow
    # Call the theming files
    theming_files
}

Mint_L_Dark_Mod_Brown () {
    # Openbox theme
    openbox_theme="Mint-L-Dark-Brown"
    # Theme accent color
    accent_color="#9c7e65"
    accent_color_rgb="rgb(156,126,101)"
    # Desktop background color
    desktop_bg_color="#32271e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-L-Dark-Mod-Brown
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Brown
    rofi_theme=Mint-L-Dark-Brown
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_L_Dark_Mod_Teal () {
    # Openbox theme
    openbox_theme="Mint-L-Dark-Teal"
    # Theme accent color
    accent_color="#579c8e"
    accent_color_rgb="rgb(87,156,142)"
    # Desktop background color
    desktop_bg_color="#1b2d29"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-L-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Teal
    rofi_theme=Mint-L-Dark-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Blue () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Blue"
    # Theme accent color
    accent_color="#0c75de"
    accent_color_rgb="rgb(12,117,222)"
    # Desktop background color
    desktop_bg_color="#202a35"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Blue
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Blue
    rofi_theme=Mint-Y-Dark-Blue
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Green () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Green"
    # Theme accent color
    accent_color="#35a854"
    accent_color_rgb="rgb(53,168,84)"
    # Desktop background color
    desktop_bg_color="#1b2d20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Green
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Green
    rofi_theme=Mint-Y-Dark-Green
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Light_Mod_Green () {
    # Openbox theme
    openbox_theme="Mint-Y-Light-Green"
    # Theme accent color
    accent_color="#35a854"
    accent_color_rgb="rgb(53,168,84)"
    # Desktop background color
    desktop_bg_color="#2f4e37"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Mint-Y-Light-Mod-Green
    qt_ct_theme=kvantum
    kvantum_theme=Mint-Y-Light-Mod-Green
    rofi_theme=Mint-Y-Light-Green
    icon_theme=Papirus-Light
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Grey () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Grey"
    # Theme accent color
    accent_color="#8e9197"
    accent_color_rgb="rgb(142,145,151)"
    # Desktop background color
    desktop_bg_color="#282a2c"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Grey
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Grey
    rofi_theme=Mint-Y-Dark-Grey
    icon_theme=Papirus-Dark
    papirus_folders=white
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Orange () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Orange"
    # Theme accent color
    accent_color="#ff7139"
    accent_color_rgb="rgb(255,113,57)"
    # Desktop background color
    desktop_bg_color="#352620"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Orange
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Orange
    rofi_theme=Mint-Y-Dark-Orange
    icon_theme=Papirus-Dark
    papirus_folders=darkcyan
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Purple () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Purple"
    # Theme accent color
    accent_color="#8c5dd9"
    accent_color_rgb="rgb(140,93,217)"
    # Desktop background color
    desktop_bg_color="#2e253e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Purple
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Purple
    rofi_theme=Mint-Y-Dark-Purple
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Red () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Red"
    # Theme accent color
    accent_color="#e82127"
    accent_color_rgb="rgb(232,33,39)"
    # Desktop background color
    desktop_bg_color="#441e20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Red
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Red
    rofi_theme=Mint-Y-Dark-Red
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Teal () {
    # Openbox theme
    openbox_theme="Mint-Y-Dark-Teal"
    # Theme accent color
    accent_color="#199ca8"
    accent_color_rgb="rgb(25,156,168)"
    # Desktop background color
    desktop_bg_color="#1b2c2e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Teal
    rofi_theme=Mint-Y-Dark-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Yaru_Blue_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Blue-Dark"
    # Theme accent color
    accent_color="#0073e5"
    accent_color_rgb="rgb(0,115,229)"
    # Desktop background color
    desktop_bg_color="#202b35"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-blue-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-blue-dark
    rofi_theme=Yaru-Blue-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Yaru_Brown_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Brown-Dark"
    # Theme accent color
    accent_color="#8c6c47"
    accent_color_rgb="rgb(140,108,71)"
    # Desktop background color
    desktop_bg_color="#32291e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-wartybrown-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-wartybrown-dark
    rofi_theme=Yaru-Brown-Dark
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Yaru_Green_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Green-Dark"
    # Theme accent color
    accent_color="#03875b"
    accent_color_rgb="rgb(3,135,91)"
    # Desktop background color
    desktop_bg_color="#1b2d27"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-viridian-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-viridian-dark
    rofi_theme=Yaru-Green-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Yaru_Orange_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Orange-Dark"
    # Theme accent color
    accent_color="#e95420"
    accent_color_rgb="rgb(233,84,32)"
    # Desktop background color
    desktop_bg_color="#362620"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-orange-dark
    rofi_theme=Yaru-Orange-Dark
    icon_theme=Papirus-Dark
    papirus_folders=yaru
    # Call the theming files
    theming_files
}

Yaru_Orange_Light () {
    # Openbox theme
    openbox_theme="Yaru-Orange-Light"
    # Theme accent color
    accent_color="#e95420"
    accent_color_rgb="rgb(233,84,32)"
    # Desktop background color
    desktop_bg_color="#4e372f"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Yaru
    qt_ct_theme=kvantum
    kvantum_theme=Yaru-orange
    rofi_theme=Yaru-Orange-Light
    icon_theme=Papirus-Light
    papirus_folders=yaru
    # Call the theming files
    theming_files
}

Yaru_Purple_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Purple-Dark"
    # Theme accent color
    accent_color="#7764d8"
    accent_color_rgb="rgb(119,100,216)"
    # Desktop background color
    desktop_bg_color="#2b2640"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-purple-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-purple-dark
    rofi_theme=Yaru-Purple-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Yaru_Sage_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Sage-Dark"
    # Theme accent color
    accent_color="#657b69"
    accent_color_rgb="rgb(101,123,105)"
    # Desktop background color
    desktop_bg_color="#232b25"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-sage-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-sage-dark
    rofi_theme=Yaru-Sage-Dark
    icon_theme=Papirus-Dark
    papirus_folders=paleorange
    # Call the theming files
    theming_files
}

Yaru_Teal_Dark () {
    # Openbox theme
    openbox_theme="Yaru-Teal-Dark"
    # Theme accent color
    accent_color="#308280"
    accent_color_rgb="rgb(48,130,128)"
    # Desktop background color
    desktop_bg_color="#1b2d2d"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-prussiangreen-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-prussiangreen-dark
    rofi_theme=Yaru-Teal-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

while true; do
    echo "========================================================================"
    echo "Select and set theming for Openbox and applications"
    echo "========================================================================"
    echo
    printf "   0) Keep current theming\n"
    printf "   1) Adwaita-Dark         \e[38;5;236m▇▇▇\e[0m\e[38;5;025m▇▇▇\e[0m\n"
    printf "   2) Adwaita-Light        \e[38;5;255m▇▇▇\e[0m\e[38;5;032m▇▇▇\e[0m\n"
    printf "   3) Mint-L-Dark-Brown    \e[38;5;237m▇▇▇\e[0m\e[38;5;137m▇▇▇\e[0m\n"
    printf "   4) Mint-L-Dark-Teal     \e[38;5;237m▇▇▇\e[0m\e[38;5;066m▇▇▇\e[0m\n"
    printf "   5) Mint-Y-Dark-Blue     \e[38;5;237m▇▇▇\e[0m\e[38;5;033m▇▇▇\e[0m\n"
    printf "   6) Mint-Y-Dark-Green    \e[38;5;237m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   7) Mint-Y-Light-Green   \e[38;5;255m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   8) Mint-Y-Dark-Grey     \e[38;5;237m▇▇▇\e[0m\e[38;5;243m▇▇▇\e[0m\n"
    printf "   9) Mint-Y-Dark-Orange   \e[38;5;237m▇▇▇\e[0m\e[38;5;208m▇▇▇\e[0m\n"
    printf "  10) Mint-Y-Dark-Purple   \e[38;5;237m▇▇▇\e[0m\e[38;5;098m▇▇▇\e[0m\n"
    printf "  11) Mint-Y-Dark-Red      \e[38;5;237m▇▇▇\e[0m\e[38;5;160m▇▇▇\e[0m\n"
    printf "  12) Mint-Y-Dark-Teal     \e[38;5;237m▇▇▇\e[0m\e[38;5;037m▇▇▇\e[0m\n"
    printf "  13) Yaru-Blue-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;027m▇▇▇\e[0m\n"
    printf "  14) Yaru-Brown-Dark      \e[38;5;236m▇▇▇\e[0m\e[38;5;094m▇▇▇\e[0m\n"
    printf "  15) Yaru-Green-Dark      \e[38;5;236m▇▇▇\e[0m\e[38;5;029m▇▇▇\e[0m\n"
    printf "  16) Yaru-Orange-Dark     \e[38;5;236m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  17) Yaru-Orange-Light    \e[38;5;255m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  18) Yaru-Purple-Dark     \e[38;5;236m▇▇▇\e[0m\e[38;5;099m▇▇▇\e[0m\n"
    printf "  19) Yaru-Sage-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;065m▇▇▇\e[0m\n"
    printf "  20) Yaru-Teal-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;030m▇▇▇\e[0m\n"
    echo

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
        7) echo "You chose Mint-Y-Light-Mod-Green";
           Mint_Y_Light_Mod_Green;
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
        13) echo "You chose Yaru-Blue-Dark";
           Yaru_Blue_Dark;
           break;;
        14) echo "You chose Yaru-Brown-Dark";
           Yaru_Brown_Dark;
           break;;
        15) echo "You chose Yaru-Green-Dark";
           Yaru_Green_Dark;
           break;;
        16) echo "You chose Yaru-Orange-Dark";
           Yaru_Orange_Dark;
           break;;
        17) echo "You chose Yaru-Orange-Light";
           Yaru_Orange_Light;
           break;;
        18) echo "You chose Yaru-Purple-Dark";
           Yaru_Purple_Dark;
           break;;
        19) echo "You chose Yaru-Sage-Dark";
           Yaru_Sage_Dark;
           break;;
        20) echo "You chose Yaru-Teal-Dark";
           Yaru_Teal_Dark;
           break;;
        *) echo "Invalid selection, please enter a number from the list.";;
    esac
done

echo "========================================================================"
echo "Reboot the system or logout/login now to complete changes"
echo "========================================================================"
