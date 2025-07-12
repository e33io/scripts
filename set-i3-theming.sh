#!/bin/bash

# ===================================================================
# Select and Set Theming for i3 and Applications
# URL: https://github.com/e33io/scripts/blob/main/set-i3-theming.sh
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

# install dark-mod-themes if needed
if [ ! -n "$(ls -d /usr/share/themes/Mint-*-Dark-Mod-* 2>/dev/null)" ]; then
    git clone https://github.com/e33io/scripts $HOME/scripts-theming
    sh $HOME/scripts-theming/install-dark-mod-themes.sh
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
    # i3bar colors
    sed -i "s/background .*/background $background/" $HOME/.config/i3/config
    sed -i "s/statusline .*/statusline $statusline/" $HOME/.config/i3/config
    sed -i "s/separator .*/separator  $separator/" $HOME/.config/i3/config
    sed -i "s/focused_workspace .*/focused_workspace  $focused_workspace/" $HOME/.config/i3/config
    sed -i "s/active_workspace .*/active_workspace   $active_workspace/" $HOME/.config/i3/config
    sed -i "s/inactive_workspace .*/inactive_workspace $inactive_workspace/" $HOME/.config/i3/config
    sed -i "s/urgent_workspace .*/urgent_workspace   $urgent_workspace/" $HOME/.config/i3/config
    sed -i "s/binding_mode .*/binding_mode       $binding_mode/" $HOME/.config/i3/config
    # i3status colors
    sed -i "s/color_good = \".*\"/color_good = \"$status_good\"/" $HOME/.config/i3/i3status.conf
    # i3 window colors
    sed -i "s/client\.focused .*/client\.focused          $client_focused/" $HOME/.config/i3/config
    sed -i "s/client\.focused_inactive .*/client\.focused_inactive $client_focused_inactive/" $HOME/.config/i3/config
    sed -i "s/client\.unfocused .*/client\.unfocused        $client_unfocused/" $HOME/.config/i3/config
    sed -i "s/client\.urgent .*/client\.urgent           $client_urgent/" $HOME/.config/i3/config
    sed -i "s/client\.placeholder .*/client\.placeholder      $client_placeholder/" $HOME/.config/i3/config
    sed -i "s/client\.background .*/client\.background       $client_background/" $HOME/.config/i3/config
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
    sed -i "s/rofi\/themes\/.*\"/rofi\/themes\/$rofi_theme\.rasi\"/" $HOME/.config/rofi/config.rasi
    sed -i "s/icon-theme: \".*\"/icon-theme: \"$icon_theme\"/" $HOME/.config/rofi/config.rasi
    # i3lock background color
    lock_bg_color=$(echo "$desktop_bg_color" | sed 's/^.//')
    sed -i "s/i3lock -n -c .*/i3lock -n -c $lock_bg_color/" $HOME/.config/i3/config
    sed -i "s/i3lock -c .* \&/i3lock -c $lock_bg_color \&/" $HOME/.local/bin/lock-suspend.sh
    # XSecureLock background color
    sed -i "s/BACKGROUND_COLOR=\".*\"/BACKGROUND_COLOR=\"$desktop_bg_color\"/" $HOME/.profile
    # Lightdm background color, GTK 3 theme and icon theme
    if [ -f "/etc/lightdm/lightdm-gtk-greeter.conf" ]; then
        sudo sed -i "s/^background =.*/background = $desktop_bg_color/" /etc/lightdm/lightdm-gtk-greeter.conf
        sudo sed -i "s/^icon-theme-name =.*/icon-theme-name = $icon_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
        sudo sed -i "s/^theme-name =.*/theme-name = $gtk_theme/" /etc/lightdm/lightdm-gtk-greeter.conf
    fi
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
        papirus-folders -C $papirus_folders --theme $icon_theme
    fi
}

Adwaita_Dark () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#1c6dcf"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#1c6dcf #1c6dcf #ffffff"
    active_workspace="#535353 #535353 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#a80e15 #a80e15 #ffffff"
    binding_mode="#6f3c95 #6f3c95 #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#1c6dcf #1c6dcf #ffffff #438de6 #1c6dcf"
    client_focused_inactive="#535353 #1e1e1e #cccccc #6e6e6e #535353"
    client_unfocused="#535353 #1e1e1e #cccccc #6e6e6e #535353"
    client_urgent="#a80e15 #a80e15 #ffffff #dc121b #a80e15"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#1c6dcf"
    # Desktop background color
    desktop_bg_color="#202a36"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    rofi_theme=Dmenu-Adwaita-Dark
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Adwaita_Darker () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#15539e"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#15539e #15539e #f4f4f4"
    active_workspace="#535353 #535353 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#a80e15 #a80e15 #f4f4f4"
    binding_mode="#6f3c95 #6f3c95 #f4f4f4"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#15539e #15539e #f4f4f4 #1961be #15539e"
    client_focused_inactive="#535353 #1e1e1e #cccccc #6e6e6e #535353"
    client_unfocused="#535353 #1e1e1e #cccccc #6e6e6e #535353"
    client_urgent="#a80e15 #a80e15 #f4f4f4 #dc121b #a80e15"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#15539e"
    # Desktop background color
    desktop_bg_color="#202a36"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Adwaita-dark
    qt_ct_theme=Adwaita-Dark
    rofi_theme=Dmenu-Adwaita-Darker
    icon_theme=Papirus-Dark
    papirus_folders=adwaita
    # Call the theming files
    theming_files
}

Adwaita_Light () {
    # i3bar colors
    background="#f6f5f4"
    statusline="#2e3436"
    separator="#3584e4"
    # i3status colors
    status_good="#2e3436"
    #                  border  bckgrd  text
    focused_workspace="#3584e4 #3584e4 #ffffff"
    active_workspace="#b3aaa2 #b3aaa2 #453f39"
    inactive_workspace="#f6f5f4 #f6f5f4 #2e3436"
    urgent_workspace="#aa0e15 #aa0e15 #ffffff"
    binding_mode="#703c97 #703c97 #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#3584e4 #3584e4 #ffffff #7bafed #3584e4"
    client_focused_inactive="#b3aaa2 #f6f5f4 #453f39 #8e8175 #b3aaa2"
    client_unfocused="#b3aaa2 #f6f5f4 #453f39 #8e8175 #b3aaa2"
    client_urgent="#aa0e15 #aa0e15 #ffffff #e6131d #aa0e15"
    client_placeholder="#f6f5f4 #f6f5f4 #2e3436 #f6f5f4 #f6f5f4"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#3584e4"
    # Desktop background color
    desktop_bg_color="#303e50"
    # GUI and TUI theme names
    prefer_dark_theme="0"
    gtk_theme=Adwaita
    qt_ct_theme=Adwaita
    rofi_theme=Dmenu-Adwaita-Light
    icon_theme=Papirus-Light
    papirus_folders=blue
    # Call the theming files
    theming_files
}

Mint_L_Dark_Mod_Brown () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#9c7e65"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#9c7e65 #9c7e65 #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#9c7e65 #9c7e65 #ffffff #b6a08d #9c7e65"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#9c7e65"
    # Desktop background color
    desktop_bg_color="#32271e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-L-Dark-Mod-Brown
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Brown
    rofi_theme=Dmenu-Mint-L-Dark-Brown
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_L_Dark_Mod_Teal () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#579c8e"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#579c8e #579c8e #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#579c8e #579c8e #ffffff #87bcb1 #579c8e"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#579c8e"
    # Desktop background color
    desktop_bg_color="#1b2d29"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-L-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-L-Dark-Mod-Teal
    rofi_theme=Dmenu-Mint-L-Dark-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Blue () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#0c75de"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#0c75de #0c75de #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#0c75de #0c75de #ffffff #3997f4 #0c75de"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#0c75de"
    # Desktop background color
    desktop_bg_color="#202a35"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Blue
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Blue
    rofi_theme=Dmenu-Mint-Y-Dark-Blue
    icon_theme=Papirus-Dark
    papirus_folders=blue
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Green () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#35a854"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#35a854 #35a854 #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#35a854 #35a854 #ffffff #5dcb7b #35a854"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#35a854"
    # Desktop background color
    desktop_bg_color="#1b2d20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Green
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Green
    rofi_theme=Dmenu-Mint-Y-Dark-Green
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Grey () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#70737a"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#70737a #70737a #ffffff"
    active_workspace="#494949 #494949 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#70737a #70737a #ffffff #8e9197 #70737a"
    client_focused_inactive="#494949 #1e1e1e #cccccc #636363 #494949"
    client_unfocused="#494949 #1e1e1e #cccccc #636363 #494949"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#70737a"
    # Desktop background color
    desktop_bg_color="#282a2c"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Grey
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Grey
    rofi_theme=Dmenu-Mint-Y-Dark-Grey
    icon_theme=Papirus-Dark
    papirus_folders=white
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Orange () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#ff7139"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#ff7139 #ff7139 #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#ff7139 #ff7139 #ffffff #ff9267 #ff7139"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#ff7139"
    # Desktop background color
    desktop_bg_color="#352620"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Orange
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Orange
    rofi_theme=Dmenu-Mint-Y-Dark-Orange
    icon_theme=Papirus-Dark
    papirus_folders=paleorange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Purple () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#8c5dd9"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#8c5dd9 #8c5dd9 #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#0855a2 #0855a2 #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#8c5dd9 #8c5dd9 #ffffff #a784e2 #8c5dd9"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#8c5dd9"
    # Desktop background color
    desktop_bg_color="#2e253e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Purple
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Purple
    rofi_theme=Dmenu-Mint-Y-Dark-Purple
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Red () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#e82127"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#e82127 #e82127 #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#eeeeee #eeeeee #c9161a"
    binding_mode="#7941a2 #7941a2 #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#e82127 #e82127 #ffffff #ed5055 #e82127"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#eeeeee #eeeeee #c9161a #c4c4c4 #eeeeee"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#e82127"
    # Desktop background color
    desktop_bg_color="#441e20"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Red
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Red
    rofi_theme=Dmenu-Mint-Y-Dark-Red
    icon_theme=Papirus-Dark
    papirus_folders=palebrown
    # Call the theming files
    theming_files
}

Mint_Y_Dark_Mod_Teal () {
    # i3bar colors
    background="#1e1e1e"
    statusline="#eeeeee"
    separator="#199ca8"
    # i3status colors
    status_good="#eeeeee"
    #                  border  bckgrd  text
    focused_workspace="#199ca8 #199ca8 #ffffff"
    active_workspace="#565656 #565656 #eeeeee"
    inactive_workspace="#1e1e1e #1e1e1e #eeeeee"
    urgent_workspace="#ae0e16 #ae0e16 #ffffff"
    binding_mode="#733d9a #733d9a #ffffff"
    # i3 colors     border  bckgrd  text    indictr child_border
    client_focused="#199ca8 #199ca8 #ffffff #1fc2d0 #199ca8"
    client_focused_inactive="#565656 #1e1e1e #cccccc #717171 #565656"
    client_unfocused="#565656 #1e1e1e #cccccc #717171 #565656"
    client_urgent="#ae0e16 #ae0e16 #ffffff #e2121d #ae0e16"
    client_placeholder="#1e1e1e #1e1e1e #eeeeee #1e1e1e #1e1e1e"
    client_background="#7f7f7f"
    # Theme accent color
    accent_color="#199ca8"
    # Desktop background color
    desktop_bg_color="#1b2c2e"
    # GUI and TUI theme names
    prefer_dark_theme="1"
    gtk_theme=Mint-Y-Dark-Mod-Teal
    qt_ct_theme=kvantum-dark
    kvantum_theme=Mint-Y-Dark-Mod-Teal
    rofi_theme=Dmenu-Mint-Y-Dark-Teal
    icon_theme=Papirus-Dark
    papirus_folders=orange
    # Call the theming files
    theming_files
}

while true; do
    echo "################################################################"
    echo "Select and set theming for i3 and applications"
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
