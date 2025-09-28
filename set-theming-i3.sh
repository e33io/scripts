#!/bin/bash

# =============================================================================
# Select and Set Theming for i3 and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-theming-i3.sh
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

# install custom-mint-themes if needed
if ! grep -q Mint $HOME/.install-info; then
    git clone https://github.com/e33io/scripts $HOME/scripts-theming
    sh $HOME/scripts-theming/install-custom-mint-themes.sh
    rm -rf $HOME/scripts-theming
fi

# install custom-yaru-themes if needed
if ! grep -q Yaru $HOME/.install-info; then
    git clone https://github.com/e33io/scripts $HOME/scripts-theming
    sh $HOME/scripts-theming/install-custom-yaru-themes.sh
    rm -rf $HOME/scripts-theming
fi

# install papirus-icon-theme and papirus-folders if needed
if ! command -v papirus-folders > /dev/null 2>&1; then
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
    # i3 window colors
    sed -i "s/client\.focused .*/client\.focused          $client_focused/" $HOME/.config/i3/config
    sed -i "s/client\.focused_inactive .*/client\.focused_inactive $client_focused_inactive/" $HOME/.config/i3/config
    sed -i "s/client\.unfocused .*/client\.unfocused        $client_unfocused/" $HOME/.config/i3/config
    sed -i "s/client\.urgent .*/client\.urgent           $client_urgent/" $HOME/.config/i3/config
    sed -i "s/client\.placeholder .*/client\.placeholder      $client_placeholder/" $HOME/.config/i3/config
    sed -i "s/client\.background .*/client\.background       $client_background/" $HOME/.config/i3/config
    # Polybar colors
    sed -i "s/bg = .*/bg = $bar_bg/" $HOME/.config/i3/polybar/config.ini
    sed -i "s/bg-focus = .*/bg-focus = $accent_color/" $HOME/.config/i3/polybar/config.ini
    sed -i "s/bg-urgent = .*/bg-urgent = $bar_bg_urg/" $HOME/.config/i3/polybar/config.ini
    sed -i "s/fg = .*/fg = $bar_fg/" $HOME/.config/i3/polybar/config.ini
    sed -i "s/fg-urgent = .*/fg-urgent = $bar_fg_urg/" $HOME/.config/i3/polybar/config.ini
    sed -i "s/bindmode = .*/bindmode = $bar_bindmode/" $HOME/.config/i3/polybar/config.ini
    sed -i "s/\%{F.*}\|\%{F-}/\%{F$accent_color}\|\%{F-}/" $HOME/.config/i3/polybar/config.ini
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
    sed -i "s/-n -c .*/-n -c $lock_bg_color/" $HOME/.config/i3/startup.conf
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
    # i3 window colors
    client_focused="#15539e #15539e #ffffff #1961be #15539e"
    client_focused_inactive="#535353 #1e1e1e #cccccc #6e6e6e #535353"
    client_unfocused="#535353 #1e1e1e #cccccc #6e6e6e #535353"
    client_urgent="#a80e15 #a80e15 #ffffff #dc121b #a80e15"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#a80e15"
    bar_fg_urg="#ffffff"
    bar_bindmode="#6f3c95"
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
    # i3 window colors
    client_focused="#3584e4 #3584e4 #ffffff #7bafed #3584e4"
    client_focused_inactive="#b3aaa2 #f6f5f4 #453f39 #8e8175 #b3aaa2"
    client_unfocused="#b3aaa2 #f6f5f4 #453f39 #8e8175 #b3aaa2"
    client_urgent="#aa0e15 #aa0e15 #ffffff #e6131d #aa0e15"
    client_placeholder="#f6f5f4 #f6f5f4 #131211 #f6f5f4 #f6f5f4"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#f6f5f4"
    bar_fg="#131211"
    bar_bg_urg="#aa0e15"
    bar_fg_urg="#ffffff"
    bar_bindmode="#703c97"
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
    # i3 window colors
    client_focused="#0c75de #0c75de #ffffff #3997f4 #0c75de"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#733d9a"
    # Theme accent color
    accent_color="#0c75de"
    # Desktop background color
    desktop_bg_color="#202a35"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Blue-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Blue-Dark
    rofi_theme=Mint-Blue-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Mint_Green_Dark () {
    # i3 window colors
    client_focused="#35a854 #35a854 #ffffff #5dcb7b #35a854"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#733d9a"
    # Theme accent color
    accent_color="#35a854"
    # Desktop background color
    desktop_bg_color="#1b2d20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Green-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Green-Dark
    rofi_theme=Mint-Green-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Green_Light () {
    # i3 window colors
    client_focused="#35a854 #35a854 #ffffff #72d38c #35a854"
    client_focused_inactive="#bfbfbf #f5f5f5 #444444 #949494 #bfbfbf"
    client_unfocused="#bfbfbf #f5f5f5 #444444 #949494 #bfbfbf"
    client_urgent="#aa0e15 #aa0e15 #ffffff #e6131d #aa0e15"
    client_placeholder="#f5f5f5 #f5f5f5 #111111 #f5f5f5 #f5f5f5"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#f5f5f5"
    bar_fg="#111111"
    bar_bg_urg="#aa0e15"
    bar_fg_urg="#ffffff"
    bar_bindmode="#703c97"
    # Theme accent color
    accent_color="#35a854"
    # Desktop background color
    desktop_bg_color="#2f4e37"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Mint-Green-Light
    qt_ct_theme=kvantum
    kvantum_theme=Mint-Green-Light
    rofi_theme=Mint-Green-Light
    icon_theme=Papirus-Light
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Grey_Dark () {
    # i3 window colors
    client_focused="#70737a #70737a #ffffff #8e9197 #70737a"
    client_focused_inactive="#494949 #1e1e1e #cccccc #636363 #494949"
    client_unfocused="#494949 #1e1e1e #cccccc #636363 #494949"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#733d9a"
    # Theme accent color
    accent_color="#70737a"
    # Desktop background color
    desktop_bg_color="#282a2c"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Grey-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Grey-Dark
    rofi_theme=Mint-Grey-Dark
    icon_theme=Papirus-Dark
    papirus_folders=white
    # Call the theming files
    theming_files
}

Mint_Orange_Dark () {
    # i3 window colors
    client_focused="#ff7139 #ff7139 #ffffff #ff9267 #ff7139"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#733d9a"
    # Theme accent color
    accent_color="#ff7139"
    # Desktop background color
    desktop_bg_color="#352620"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Orange-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Orange-Dark
    rofi_theme=Mint-Orange-Dark
    icon_theme=Papirus-Dark
    papirus_folders=darkcyan
    # Call the theming files
    theming_files
}

Mint_Purple_Dark () {
    # i3 window colors
    client_focused="#8c5dd9 #8c5dd9 #ffffff #a784e2 #8c5dd9"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#0855a2"
    # Theme accent color
    accent_color="#8c5dd9"
    # Desktop background color
    desktop_bg_color="#2e253e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Purple-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Purple-Dark
    rofi_theme=Mint-Purple-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Red_Dark () {
    # i3 window colors
    client_focused="#e82127 #e82127 #ffffff #ed5055 #e82127"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#eeeeee #eeeeee #c9161a #c4c4c4 #eeeeee"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#eeeeee"
    bar_fg_urg="#c9161a"
    bar_bindmode="#7941a2"
    # Theme accent color
    accent_color="#e82127"
    # Desktop background color
    desktop_bg_color="#441e20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Red-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Red-Dark
    rofi_theme=Mint-Red-Dark
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_Teal_Dark () {
    # i3 window colors
    client_focused="#199ca8 #199ca8 #ffffff #1fc2d0 #199ca8"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#733d9a"
    # Theme accent color
    accent_color="#199ca8"
    # Desktop background color
    desktop_bg_color="#1b2c2e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Teal-Dark
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Teal-Dark
    rofi_theme=Mint-Teal-Dark
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Yaru_Blue_Dark () {
    # i3 window colors
    client_focused="#0073e5 #0073e5 #ffffff #2c96ff #0073e5"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    # i3 window colors
    client_focused="#8c6c47 #8c6c47 #ffffff #ae895f #8c6c47"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    # i3 window colors
    client_focused="#03875b #03875b #ffffff #04aa73 #03875b"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Yaru_Orange_Dark () {
    # i3 window colors
    client_focused="#e95420 #e95420 #ffffff #f08b69 #e95420"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    # i3 window colors
    client_focused="#e95420 #e95420 #ffffff #f08b69 #e95420"
    client_focused_inactive="#afafaf #f7f7f7 #444444 #868686 #afafaf"
    client_unfocused="#afafaf #f7f7f7 #444444 #868686 #afafaf"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#f7f7f7 #f7f7f7 #111111 #f7f7f7 #f7f7f7"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#f7f7f7"
    bar_fg="#111111"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    # i3 window colors
    client_focused="#7764d8 #7764d8 #ffffff #9789e1 #7764d8"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#16549f"
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
    # i3 window colors
    client_focused="#657b69 #657b69 #ffffff #839987 #657b69"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    # i3 window colors
    client_focused="#308280 #308280 #ffffff #3da3a0 #308280"
    client_focused_inactive="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_unfocused="#4e4e4e #1e1e1e #cccccc #696969 #4e4e4e"
    client_urgent="#ac0e16 #ac0e16 #ffffff #c8101a #ac0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Polybar colors
    bar_bg="#1e1e1e"
    bar_fg="#eeeeee"
    bar_bg_urg="#ae0e16"
    bar_fg_urg="#ffffff"
    bar_bindmode="#723c99"
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
    echo "Select and set theming for i3 and applications"
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
