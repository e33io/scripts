#!/bin/bash

# =============================================================================
# Select and Set Theming for JWM and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-theming-jwm.sh
# -----------------------------------------------------------------------------
# Use this script at your own risk, it will overwrite existing files!
# NOTE: Only use with JWM installed via e33io script!
# =============================================================================

if [ "$(id -u)" = 0 ]; then
    echo "========================================================================"
    echo "NOTE! This script will not run for the root user!"
    echo "Run this script as a normal user."
    echo "You will be asked for a sudo password when necessary."
    echo "========================================================================"
    exit 1
fi

clear

theming_files () {
    # JWM theme
    sed -i "s/jwm\/themes\/.*<\/Include>/jwm\/themes\/$jwm_theme<\/Include>/" ~/.config/jwm/jwmrc
    # Polybar colors
    sed -i -e "s/bg = .*/bg = $bar_bg/" \
    -e "s/bg-act = .*/bg-act = $accent_color/" \
    -e "s/bg-occ = .*/bg-occ = $bar_bg/" \
    -e "s/fg = .*/fg = $bar_fg/" \
    -e "s/\%{F.*}\|\%{F-}/\%{F$accent_color}\|\%{F-}/" ~/.config/jwm/polybar/config.ini
    # GTK 2 theme and icon theme
    sed -i -e "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$gtk_theme\"/" \
    -e "s/gtk-icon-theme-name=\".*\"/gtk-icon-theme-name=\"$icon_theme\"/" ~/.gtkrc-2.0
    # GTK 3 theme and icon theme
    sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/" \
    -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/" \
    -e "s/gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$prefer_dark_theme/" \
    ~/.config/gtk-3.0/settings.ini
    # Qt5ct theme and icon theme
    sed -i -e "s/^style=.*/style=$qt_ct_theme/" \
    -e "s/icon_theme=.*/icon_theme=$icon_theme/" ~/.config/qt5ct/qt5ct.conf
    # Qt6ct theme and icon theme
    sed -i -e "s/^style=.*/style=$qt_ct_theme/" \
    -e "s/icon_theme=.*/icon_theme=$icon_theme/" ~/.config/qt6ct/qt6ct.conf
    # Kvantum theme
    printf "[General]\ntheme=" | tee ~/.config/Kvantum/kvantum.kvconfig > /dev/null
    sed -i "s/theme=.*/theme=$kvantum_theme/" ~/.config/Kvantum/kvantum.kvconfig
    # Rofi theme and icon theme
    if grep -q "Dmenu" ~/.config/rofi/config.rasi; then
        rofi_style=Dmenu
    elif grep -q "Floating" ~/.config/rofi/config.rasi; then
        rofi_style=Floating
    elif grep -q "Panel" ~/.config/rofi/config.rasi; then
        rofi_style=Panel
    fi
    sed -i -e "s/rofi\/themes\/.*\"/rofi\/themes\/$rofi_style-$rofi_theme\.rasi\"/" \
    -e "s/icon-theme: \".*\"/icon-theme: \"$icon_theme\"/" ~/.config/rofi/config.rasi
    # i3lock background color
    lock_bg_color=$(echo "$desktop_bg_color" | sed 's/^.//')
    sed -i "s/-n -c .* \&/-n -c $lock_bg_color \&/" ~/.config/jwm/autostart
    sed -i "s/-c .* \&/-c $lock_bg_color \&/" ~/.local/bin/lock-suspend.sh
    # XSecureLock background color
    sed -i "s/BACKGROUND_COLOR=\".*\"/BACKGROUND_COLOR=\"$desktop_bg_color\"/" ~/.profile
    # Lightdm background color, GTK 3 theme and icon theme
    sudo sed -i -e "s/^background =.*/background = $desktop_bg_color/" \
    -e "s/^icon-theme-name =.*/icon-theme-name = $icon_theme/" \
    -e "s/^theme-name =.*/theme-name = $gtk_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
    # Papirus folders color
    papirus-folders -C $papirus_folders --theme $icon_theme > /dev/null
    # CAVA foreground color
    if [ -f ~/.config/cava/config ]; then
        sed -i "s/^foreground = .*/foreground = '$accent_color'/" ~/.config/cava/config
    fi
}

Adwaita_Dark () {
    # JWM theme
    jwm_theme="JWM-Adwaita-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#15539e"
    # Desktop background color
    desktop_bg_color="#202a36"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    rofi_theme=Adwaita-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Adwaita_Light () {
    # JWM theme
    jwm_theme="JWM-Adwaita-Light"
    # Polybar colors
    bar_bg="#f6f5f4"
    bar_fg="#111111"
    # Theme accent color
    accent_color="#3584e4"
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

Mint_Blue_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Blue-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#0c75de"
    # Desktop background color
    desktop_bg_color="#202a35"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Blue-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Blue-Dark
    rofi_theme=Mint-Mod-Blue-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Mint_Green_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Green-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#35a854"
    # Desktop background color
    desktop_bg_color="#1b2d20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Green-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Green-Dark
    rofi_theme=Mint-Mod-Green-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Green_Light () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Green-Light"
    # Polybar colors
    bar_bg="#f5f5f5"
    bar_fg="#111111"
    # Theme accent color
    accent_color="#35a854"
    # Desktop background color
    desktop_bg_color="#2f4e37"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Mint-Mod-Green-Light
    qt_ct_theme=kvantum
    kvantum_theme=Mint-Mod-Green-Light
    rofi_theme=Mint-Mod-Green-Light
    icon_theme=Papirus-Light
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Grey_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Grey-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#70737a"
    # Desktop background color
    desktop_bg_color="#282a2c"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Grey-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Grey-Dark
    rofi_theme=Mint-Mod-Grey-Dark
    icon_theme=Papirus-Dark
    papirus_folders=white
    # Call the theming files
    theming_files
}

Mint_Orange_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Orange-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#ff7139"
    # Desktop background color
    desktop_bg_color="#352620"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Orange-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Orange-Dark
    rofi_theme=Mint-Mod-Orange-Dark
    icon_theme=Papirus-Dark
    papirus_folders=darkcyan
    # Call the theming files
    theming_files
}

Mint_Purple_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Purple-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#8c5dd9"
    # Desktop background color
    desktop_bg_color="#2e253e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Purple-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Purple-Dark
    rofi_theme=Mint-Mod-Purple-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Red_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Red-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#e82127"
    # Desktop background color
    desktop_bg_color="#451718"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Red-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Red-Dark
    rofi_theme=Mint-Mod-Red-Dark
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_Teal_Dark () {
    # JWM theme
    jwm_theme="JWM-Mint-Mod-Teal-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#199ca8"
    # Desktop background color
    desktop_bg_color="#1b2c2e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Mod-Teal-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Mod-Teal-Dark
    rofi_theme=Mint-Mod-Teal-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Yaru_Blue_Dark () {
    # JWM theme
    jwm_theme="JWM-Yaru-Blue-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#0073e5"
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
    # JWM theme
    jwm_theme="JWM-Yaru-Brown-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#8c6c47"
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
    # JWM theme
    jwm_theme="JWM-Yaru-Green-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#03875b"
    # Desktop background color
    desktop_bg_color="#1b2d27"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Yaru-viridian-dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Yaru-viridian-dark
    rofi_theme=Yaru-Green-Dark
    icon_theme=Papirus-Dark
    papirus_folders=paleorange
    # Call the theming files
    theming_files
}

Yaru_Orange_Dark () {
    # JWM theme
    jwm_theme="JWM-Yaru-Orange-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#e95420"
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
    # JWM theme
    jwm_theme="JWM-Yaru-Orange-Light"
    # Polybar colors
    bar_bg="#f7f7f7"
    bar_fg="#111111"
    # Theme accent color
    accent_color="#e95420"
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
    # JWM theme
    jwm_theme="JWM-Yaru-Purple-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#7764d8"
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
    # JWM theme
    jwm_theme="JWM-Yaru-Sage-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#657b69"
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
    # JWM theme
    jwm_theme="JWM-Yaru-Teal-Dark"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    # Theme accent color
    accent_color="#308280"
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
    echo "Select and set theming for JWM and applications"
    echo "========================================================================"
    echo
    printf "   0) Keep current theming\n"
    printf "   1) Adwaita-Dark           \e[38;5;236m▇▇▇\e[0m\e[38;5;025m▇▇▇\e[0m\n"
    printf "   2) Adwaita-Light          \e[38;5;255m▇▇▇\e[0m\e[38;5;032m▇▇▇\e[0m\n"
    printf "   3) Mint-Mod-Blue-Dark     \e[38;5;237m▇▇▇\e[0m\e[38;5;033m▇▇▇\e[0m\n"
    printf "   4) Mint-Mod-Green-Dark    \e[38;5;237m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   5) Mint-Mod-Green-Light   \e[38;5;255m▇▇▇\e[0m\e[38;5;035m▇▇▇\e[0m\n"
    printf "   6) Mint-Mod-Grey-Dark     \e[38;5;237m▇▇▇\e[0m\e[38;5;243m▇▇▇\e[0m\n"
    printf "   7) Mint-Mod-Orange-Dark   \e[38;5;237m▇▇▇\e[0m\e[38;5;208m▇▇▇\e[0m\n"
    printf "   8) Mint-Mod-Purple-Dark   \e[38;5;237m▇▇▇\e[0m\e[38;5;098m▇▇▇\e[0m\n"
    printf "   9) Mint-Mod-Red-Dark      \e[38;5;237m▇▇▇\e[0m\e[38;5;160m▇▇▇\e[0m\n"
    printf "  10) Mint-Mod-Teal-Dark     \e[38;5;237m▇▇▇\e[0m\e[38;5;037m▇▇▇\e[0m\n"
    printf "  11) Yaru-Blue-Dark         \e[38;5;236m▇▇▇\e[0m\e[38;5;027m▇▇▇\e[0m\n"
    printf "  12) Yaru-Brown-Dark        \e[38;5;236m▇▇▇\e[0m\e[38;5;094m▇▇▇\e[0m\n"
    printf "  13) Yaru-Green-Dark        \e[38;5;236m▇▇▇\e[0m\e[38;5;029m▇▇▇\e[0m\n"
    printf "  14) Yaru-Orange-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  15) Yaru-Orange-Light      \e[38;5;255m▇▇▇\e[0m\e[38;5;166m▇▇▇\e[0m\n"
    printf "  16) Yaru-Purple-Dark       \e[38;5;236m▇▇▇\e[0m\e[38;5;099m▇▇▇\e[0m\n"
    printf "  17) Yaru-Sage-Dark         \e[38;5;236m▇▇▇\e[0m\e[38;5;065m▇▇▇\e[0m\n"
    printf "  18) Yaru-Teal-Dark         \e[38;5;236m▇▇▇\e[0m\e[38;5;030m▇▇▇\e[0m\n"
    echo

    read -rp "Which theme do you want to use? " n
    case $n in
        0) echo "You chose to keep current theming";
           exit 1;;
        1) echo "You chose Adwaita-Dark, applying changes...";
           Adwaita_Dark;
           break;;
        2) echo "You chose Adwaita-Light, applying changes...";
           Adwaita_Light;
           break;;
        3) echo "You chose Mint-Mod-Blue-Dark, applying changes...";
           Mint_Blue_Dark;
           break;;
        4) echo "You chose Mint-Mod-Green-Dark, applying changes...";
           Mint_Green_Dark;
           break;;
        5) echo "You chose Mint-Mod-Green-Light, applying changes...";
           Mint_Green_Light;
           break;;
        6) echo "You chose Mint-Mod-Grey-Dark, applying changes...";
           Mint_Grey_Dark;
           break;;
        7) echo "You chose Mint-Mod-Orange-Dark, applying changes...";
           Mint_Orange_Dark;
           break;;
        8) echo "You chose Mint-Mod-Purple-Dark, applying changes...";
           Mint_Purple_Dark;
           break;;
        9) echo "You chose Mint-Mod-Red-Dark, applying changes...";
           Mint_Red_Dark;
           break;;
        10) echo "You chose Mint-Mod-Teal-Dark, applying changes...";
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
