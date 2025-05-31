#!/bin/bash

# ====================================================================
# Gnome Dconf Setup
# URL: https://github.com/e33io/scripts/blob/main/gnome-dconf-setup.sh
# ====================================================================

dconf write /ca/desrt/dconf-editor/window-height "700"
dconf write /ca/desrt/dconf-editor/window-is-maximized "false"
dconf write /ca/desrt/dconf-editor/window-width "900"

dconf write /com/ftpix/transparentbar/transparency "75"

dconf write /org/gnome/Music/window-maximized "false"
dconf write /org/gnome/Music/window-size "[1061, 773]"

dconf write /org/gnome/Ptyxis/cursor-blink-mode "'on'"
dconf write /org/gnome/Ptyxis/cursor-shape "'block'"
dconf write /org/gnome/Ptyxis/default-columns "uint32 104"
dconf write /org/gnome/Ptyxis/default-profile-uuid "'3df59f1866e9fcb42c7806ef67fbef8b'"
dconf write /org/gnome/Ptyxis/default-rows "uint32 32"
dconf write /org/gnome/Ptyxis/font-name "'SovranMono Nerd Font 12'"
dconf write /org/gnome/Ptyxis/profile-uuids "['3df59f1866e9fcb42c7806ef67fbef8b']"
dconf write /org/gnome/Ptyxis/prompt-on-close "false"
dconf write /org/gnome/Ptyxis/restore-session "false"
dconf write /org/gnome/Ptyxis/restore-window-size "false"
dconf write /org/gnome/Ptyxis/use-system-font "false"
dconf write /org/gnome/Ptyxis/window-size "(uint32 104, uint32 32)"
dconf write /org/gnome/Ptyxis/Profiles/3df59f1866e9fcb42c7806ef67fbef8b/bold-is-bright "true"
dconf write /org/gnome/Ptyxis/Profiles/3df59f1866e9fcb42c7806ef67fbef8b/palette "'monokai-mod'"

dconf write /org/gnome/TextEditor/custom-font "'SovranMono Nerd Font Propo 12'"
dconf write /org/gnome/TextEditor/indent-style "'space'"
dconf write /org/gnome/TextEditor/restore-session "false"
dconf write /org/gnome/TextEditor/show-line-numbers "true"
dconf write /org/gnome/TextEditor/spellcheck "false"
dconf write /org/gnome/TextEditor/style-scheme "'monokai-mod'"
dconf write /org/gnome/TextEditor/tab-width "uint32 4"
dconf write /org/gnome/TextEditor/use-system-font "false"

dconf write /org/gnome/control-center/last-panel "'background'"
dconf write /org/gnome/control-center/window-state "(980, 672, false)"

# Debian specific settings
if [ -f "/etc/debian_version" ]; then
    dconf write /org/gnome/desktop/app-folders/folder-children "['System', 'Utilities', 'YaST', 'Pardus', '5e50329d-2752-4667-84e7-18ad4ad19750']"
    dconf write /org/gnome/desktop/app-folders/folders/5e50329d-2752-4667-84e7-18ad4ad19750/apps "['libreoffice-calc.desktop', 'libreoffice-writer.desktop', 'libreoffice-impress.desktop', 'libreoffice-draw.desktop', 'libreoffice-startcenter.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Contacts.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/5e50329d-2752-4667-84e7-18ad4ad19750/name "'Office'"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/categories "['X-Pardus-Apps']"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/name "'X-Pardus-Apps.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/System/apps "['org.gnome.SystemMonitor.desktop', 'nm-connection-editor.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.baobab.desktop', 'org.gnome.Logs.desktop', 'org.freedesktop.MalcontentControl.desktop', 'im-config.desktop', 'input-remapper-gtk.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/System/name "'X-GNOME-Shell-System.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/System/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/apps "['org.gnome.Connections.desktop', 'org.gnome.Evince.desktop', 'org.gnome.Loupe.desktop', 'simple-scan.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.Snapshot.desktop', 'org.gnome.font-viewer.desktop', 'org.gnome.Characters.desktop', 'yelp.desktop', 'org.gnome.Tour.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/name "'X-GNOME-Shell-Utilities.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/categories "['X-SuSE-YaST']"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/name "'suse-yast.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/translate "true"
fi

# Arch specific settings
if [ -f "/etc/pacman.conf" ]; then
    dconf write /org/gnome/desktop/app-folders/folder-children "['System', 'Utilities', 'YaST', 'Pardus', '7385973a-bf95-4858-ac66-ad784a3ea649']"
    dconf write /org/gnome/desktop/app-folders/folders/7385973a-bf95-4858-ac66-ad784a3ea649/apps "['libreoffice-calc.desktop', 'libreoffice-writer.desktop', 'libreoffice-impress.desktop', 'libreoffice-draw.desktop', 'libreoffice-math.desktop', 'libreoffice-base.desktop', 'libreoffice-startcenter.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Contacts.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/7385973a-bf95-4858-ac66-ad784a3ea649/name "'Office'"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/categories "['X-Pardus-Apps']"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/name "'X-Pardus-Apps.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/System/apps "['org.gnome.SystemMonitor.desktop', 'org.gnome.baobab.desktop', 'org.gnome.DiskUtility.desktop', 'qt5ct.desktop', 'qt6ct.desktop', 'org.gnome.Logs.desktop', 'nm-connection-editor.desktop', 'org.freedesktop.MalcontentControl.desktop', 'htop.desktop', 'avahi-discover.desktop', 'bvnc.desktop', 'bssh.desktop', 'org.torproject.torbrowser-launcher.settings.desktop', 'micro.desktop', 'vim.desktop', 'octopi-cachecleaner.desktop', 'octopi-notifier.desktop', 'octopi-repoeditor.desktop', 'assistant.desktop', 'qdbusviewer.desktop', 'linguist.desktop', 'qv4l2.desktop', 'qvidcap.desktop', 'designer.desktop', 'org.gnome.Extensions.desktop', 'lstopo.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/System/name "'X-GNOME-Shell-System.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/System/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/apps "['org.gnome.Connections.desktop', 'org.gnome.Evince.desktop', 'org.gnome.Loupe.desktop', 'org.gnome.SimpleScan.desktop', 'org.gnome.font-viewer.desktop', 'org.gnome.Characters.desktop', 'org.gnome.Snapshot.desktop', 'input-remapper-gtk.desktop', 'yelp.desktop', 'org.gnome.Tour.desktop', 'cmake-gui.desktop', 'org.gnome.Console.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/name "'X-GNOME-Shell-Utilities.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/categories "['X-SuSE-YaST']"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/name "'suse-yast.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/translate "true"
fi

# Fedora specific settings
if [ -f "/etc/dnf/dnf.conf" ]; then
    dconf write /org/gnome/desktop/app-folders/folder-children "['System', 'Utilities', 'YaST', 'Pardus', 'a8997e7e-188b-4a9b-b07e-c19a3d4cb1d8']"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/categories "['X-Pardus-Apps']"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/name "'X-Pardus-Apps.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/Pardus/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/System/apps "['org.gnome.SystemMonitor.desktop', 'org.gnome.baobab.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.Logs.desktop', 'org.freedesktop.MalcontentControl.desktop', 'org.freedesktop.GnomeAbrt.desktop', 'htop.desktop', 'org.torproject.torbrowser-launcher.settings.desktop', 'input-remapper-gtk.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/System/name "'X-GNOME-Shell-System.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/System/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/apps "['org.gnome.Connections.desktop', 'org.gnome.Evince.desktop', 'org.gnome.Loupe.desktop', 'simple-scan.desktop', 'org.gnome.font-viewer.desktop', 'org.gnome.Characters.desktop', 'org.gnome.Tour.desktop', 'yelp.desktop', 'org.gnome.Snapshot.desktop', 'hp-uiscan.desktop', 'hplip.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/name "'X-GNOME-Shell-Utilities.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/categories "['X-SuSE-YaST']"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/name "'suse-yast.directory'"
    dconf write /org/gnome/desktop/app-folders/folders/YaST/translate "true"
    dconf write /org/gnome/desktop/app-folders/folders/a8997e7e-188b-4a9b-b07e-c19a3d4cb1d8/apps "['libreoffice-calc.desktop', 'libreoffice-writer.desktop', 'libreoffice-impress.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Contacts.desktop']"
    dconf write /org/gnome/desktop/app-folders/folders/a8997e7e-188b-4a9b-b07e-c19a3d4cb1d8/name "'Office'"
fi

dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/gnome/drool-l.svg'"
dconf write /org/gnome/desktop/background/picture-uri-dark "'file:///usr/share/backgrounds/gnome/drool-d.svg'"

dconf write /org/gnome/desktop/interface/clock-format "'24h'"
dconf write /org/gnome/desktop/interface/clock-show-date "true"
dconf write /org/gnome/desktop/interface/clock-show-seconds "true"
dconf write /org/gnome/desktop/interface/clock-show-weekday "true"
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
# Debian specific settings
if [ -f "/etc/debian_version" ]; then
    dconf write /org/gnome/desktop/interface/document-font-name "'Inter 11'"
    dconf write /org/gnome/desktop/interface/font-name "'Inter 11'"
fi
dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
dconf write /org/gnome/desktop/interface/icon-theme "'Papirus-Dark'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'SovranMono Nerd Font Propo 12'"

dconf write /org/gnome/desktop/notifications/show-in-lock-screen "false"

dconf write /org/gnome/desktop/screensaver/picture-uri "'file:///usr/share/backgrounds/gnome/drool-l.svg'"

dconf write /org/gnome/desktop/wm/keybindings/close "['<Super><Shift>q', '<Alt>F4']"
dconf write /org/gnome/desktop/wm/keybindings/maximize-horizontally "['<Super><Shift>h']"
dconf write /org/gnome/desktop/wm/keybindings/maximize-vertically "['<Super><Shift>v']"
dconf write /org/gnome/desktop/wm/keybindings/minimize "['<Super><Shift>i']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-center "['<Super><Shift>space']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-left "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-right "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-monitor-up "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-e "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-n "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-s "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-w "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-1 "['<Super><Shift>1']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-10 "['<Super><Shift>0']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-11 "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-12 "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-2 "['<Super><Shift>2']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-3 "['<Super><Shift>3']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-4 "['<Super><Shift>4']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5 "['<Super><Shift>5']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-6 "['<Super><Shift>6']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-7 "['<Super><Shift>7']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-8 "['<Super><Shift>8']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-9 "['<Super><Shift>9']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-down "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-last "@as []"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-left "['<Super><Shift>Left']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-right "['<Super><Shift>Right']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-up "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-input-source-backward "['<Shift>XF86Keyboard']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-1 "['<Super>1']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-10 "['<Super>0']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-11 "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-12 "@as []"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-2 "['<Super>2']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-3 "['<Super>3']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-4 "['<Super>4']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-5 "['<Super>5']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-6 "['<Super>6']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-7 "['<Super>7']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-8 "['<Super>8']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-9 "['<Super>9']"
dconf write /org/gnome/desktop/wm/keybindings/toggle-fullscreen "['<Super><Shift>f']"
dconf write /org/gnome/desktop/wm/keybindings/toggle-maximized "['<Super><Shift>m', '<Alt>F10']"

dconf write /org/gnome/desktop/wm/preferences/button-layout "'appmenu:minimize,maximize,close'"
dconf write /org/gnome/desktop/wm/preferences/focus-mode "'sloppy'"
dconf write /org/gnome/desktop/wm/preferences/focus-new-windows "'smart'"
dconf write /org/gnome/desktop/wm/preferences/num-workspaces "6"
dconf write /org/gnome/desktop/wm/preferences/raise-on-click "true"

dconf write /org/gnome/evolution-data-server/migrated "true"

dconf write /org/gnome/mutter/center-new-windows "false"
dconf write /org/gnome/mutter/dynamic-workspaces "false"
# Arch specific settings
if [ -f "/etc/pacman.conf" ]; then
    dconf write /org/gnome/mutter/experimental-features "['scale-monitor-framebuffer', 'xwayland-native-scaling']"
fi

dconf write /org/gnome/nautilus/icon-view/default-zoom-level "'small-plus'"

dconf write /org/gnome/nautilus/list-view/use-tree-view "true"

dconf write /org/gnome/nautilus/preferences/date-time-format "'detailed'"
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'icon-view'"
dconf write /org/gnome/nautilus/preferences/migrated-gtk-settings "true"
dconf write /org/gnome/nautilus/preferences/search-filter-time-type "'last_modified'"
dconf write /org/gnome/nautilus/preferences/show-hidden-files "true"

dconf write /org/gnome/nautilus/window-state/initial-size "(890, 660)"
dconf write /org/gnome/nautilus/window-state/initial-size-file-chooser "(890, 550)"

dconf write /org/gnome/settings-daemon/plugins/color/night-light-schedule-automatic "false"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/screensaver "['<Super>x', '<Super>l']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/www "['<Super>b']"
# Debian specific settings
if [ -f "/etc/debian_version" ]; then
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>Return'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'ptyxis --new-window'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Gnome Terminal'"
fi
# Arch specific settings
if [ -f "/etc/pacman.conf" ]; then
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>Return'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'ghostty'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Ghostty Terminal'"
fi
# Fedora specific settings
if [ -f "/etc/dnf/dnf.conf" ]; then
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>Return'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'ptyxis --new-window'"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Gnome Terminal'"
fi
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Shift><Super>Return'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'nautilus --new-window'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Gnome File Manager'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'gnome-text-editor'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'Gnome Text Editor'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/binding "'<Shift><Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/command "'gnome-text-editor --new-window'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/name "'Gnome Text Editor - New Window'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/binding "'<Super>c'"
# Flatpak specific settings
if [ -d "/var/lib/flatpak/app/org.signal.Signal" ]; then
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/command "'flatpak run org.signal.Signal'"
else
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/command "'signal-desktop'"
fi
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/name "'Signal App'"

dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"

# Debian specific settings
if [ -f "/etc/debian_version" ]; then
    dconf write /org/gnome/shell/app-picker-layout "[{'org.gnome.Epiphany.desktop': <{'position': <0>}>, '5e50329d-2752-4667-84e7-18ad4ad19750': <{'position': <1>}>, 'org.gnome.Calculator.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Weather.desktop': <{'position': <4>}>, 'org.gnome.Maps.desktop': <{'position': <5>}>, 'org.gnome.Totem.desktop': <{'position': <6>}>, 'timeshift-gtk.desktop': <{'position': <7>}>, 'org.gnome.Settings.desktop': <{'position': <8>}>, 'org.gnome.tweaks.desktop': <{'position': <9>}>, 'com.mattjakeman.ExtensionManager.desktop': <{'position': <10>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <11>}>, 'Utilities': <{'position': <12>}>, 'System': <{'position': <13>}>, 'synaptic.desktop': <{'position': <14>}>, 'org.gnome.Software.desktop': <{'position': <15>}>, 'mintstick.desktop': <{'position': <16>}>, 'mintstick-format.desktop': <{'position': <17>}>, 'filezilla.desktop': <{'position': <18>}>, 'soundconverter.desktop': <{'position': <19>}>, 'nl.hjdskes.gcolor3.desktop': <{'position': <20>}>}]"

    dconf write /org/gnome/shell/enabled-extensions "['ubuntu-appindicators@ubuntu.com', 'window-title-is-back@fthx', 'transparent-top-bar@ftpix.com', 'space-bar@luchrioh', 'disable-workspace-switcher-overlay@cleardevice', 'dash-to-dock@micxgx.gmail.com']"

    dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'signal-desktop.desktop', 'org.gnome.Rhythmbox3.desktop', 'org.darktable.darktable.desktop', 'gimp.desktop', 'org.inkscape.Inkscape.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Ptyxis.desktop']"
fi

# Arch specific settings
if [ -f "/etc/pacman.conf" ]; then
    dconf write /org/gnome/shell/app-picker-layout "[{'org.gnome.Epiphany.desktop': <{'position': <0>}>, '7385973a-bf95-4858-ac66-ad784a3ea649': <{'position': <1>}>, 'org.gnome.Calculator.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Weather.desktop': <{'position': <4>}>, 'org.gnome.Maps.desktop': <{'position': <5>}>, 'org.gnome.Totem.desktop': <{'position': <6>}>, 'org.gnome.Decibels.desktop': <{'position': <7>}>, 'org.gnome.Settings.desktop': <{'position': <8>}>, 'org.gnome.tweaks.desktop': <{'position': <9>}>, 'com.mattjakeman.ExtensionManager.desktop': <{'position': <10>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <11>}>, 'Utilities': <{'position': <12>}>, 'System': <{'position': <13>}>, 'timeshift-gtk.desktop': <{'position': <14>}>, 'octopi.desktop': <{'position': <15>}>, 'mintstick.desktop': <{'position': <16>}>, 'mintstick-format.desktop': <{'position': <17>}>, 'filezilla.desktop': <{'position': <18>}>, 'nl.hjdskes.gcolor3.desktop': <{'position': <19>}>}]"

    dconf write /org/gnome/shell/enabled-extensions "['appindicatorsupport@rgcjonas.gmail.com', 'dash-to-dock@micxgx.gmail.com', 'disable-workspace-switcher-overlay@cleardevice', 'space-bar@luchrioh', 'transparent-top-bar@ftpix.com', 'window-title-is-back@fthx']"

    dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'org.torproject.torbrowser-launcher.desktop', 'signal-desktop.desktop', 'org.gnome.Music.desktop', 'org.darktable.darktable.desktop', 'gimp.desktop', 'org.inkscape.Inkscape.desktop', 'org.gnome.TextEditor.desktop', 'com.mitchellh.ghostty.desktop']"
fi

# Fedora specific settings
if [ -f "/etc/dnf/dnf.conf" ]; then
    dconf write /org/gnome/shell/app-picker-layout "[{'org.mozilla.firefox.desktop': <{'position': <0>}>, 'a8997e7e-188b-4a9b-b07e-c19a3d4cb1d8': <{'position': <1>}>, 'org.gnome.Calculator.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Weather.desktop': <{'position': <4>}>, 'org.gnome.Maps.desktop': <{'position': <5>}>, 'org.gnome.Totem.desktop': <{'position': <6>}>, 'org.gnome.Decibels.desktop': <{'position': <7>}>, 'org.gnome.Settings.desktop': <{'position': <8>}>, 'org.gnome.tweaks.desktop': <{'position': <9>}>, 'com.mattjakeman.ExtensionManager.desktop': <{'position': <10>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <11>}>, 'Utilities': <{'position': <12>}>, 'System': <{'position': <13>}>, 'timeshift-gtk.desktop': <{'position': <14>}>, 'org.gnome.Software.desktop': <{'position': <15>}>, 'org.fedoraproject.MediaWriter.desktop': <{'position': <16>}>, 'org.gnome.Boxes.desktop': <{'position': <17>}>, 'filezilla.desktop': <{'position': <18>}>, 'nl.hjdskes.gcolor3.desktop': <{'position': <19>}>}]"

    dconf write /org/gnome/shell/disabled-extensions "['background-logo@fedorahosted.org']"
    dconf write /org/gnome/shell/enabled-extensions "['dash-to-dock@micxgx.gmail.com', 'transparent-top-bar@ftpix.com', 'disable-workspace-switcher-overlay@cleardevice', 'space-bar@luchrioh', 'window-title-is-back@fthx', 'appindicatorsupport@rgcjonas.gmail.com']"

    dconf write /org/gnome/shell/favorite-apps "['org.gnome.Nautilus.desktop', 'brave-browser.desktop', 'org.torproject.torbrowser-launcher.desktop', 'org.signal.Signal.desktop', 'org.gnome.Rhythmbox3.desktop', 'org.darktable.darktable.desktop', 'gimp.desktop', 'org.inkscape.Inkscape.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Ptyxis.desktop']"
fi

dconf write /org/gnome/shell/last-selected-power-profile "'performance'"

dconf write /org/gnome/shell/extensions/appindicator/icon-opacity "255"
dconf write /org/gnome/shell/extensions/appindicator/icon-size "16"

dconf write /org/gnome/shell/extensions/dash-to-dock/autohide-in-fullscreen "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-color "'rgb(0,0,0)'"
dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity "0.75"
dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'minimize-or-previews'"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-background-color "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size "48"
dconf write /org/gnome/shell/extensions/dash-to-dock/disable-overview-on-startup "true"
dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'BOTTOM'"
dconf write /org/gnome/shell/extensions/dash-to-dock/height-fraction "0.90"
dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/intellihide-mode "'ALL_WINDOWS'"
dconf write /org/gnome/shell/extensions/dash-to-dock/middle-click-action "'launch'"
dconf write /org/gnome/shell/extensions/dash-to-dock/shift-click-action "'minimize'"
dconf write /org/gnome/shell/extensions/dash-to-dock/shift-middle-click-action "'launch'"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-mounts "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash "false"
dconf write /org/gnome/shell/extensions/dash-to-dock/transparency-mode "'FIXED'"

dconf write /org/gnome/shell/extensions/space-bar/appearance/active-workspace-background-color "'rgba(0,0,0,0)'"
dconf write /org/gnome/shell/extensions/space-bar/appearance/active-workspace-border-radius "32"
dconf write /org/gnome/shell/extensions/space-bar/appearance/active-workspace-text-color "'rgb(255,255,255)'"
dconf write /org/gnome/shell/extensions/space-bar/appearance/application-styles "'.space-bar {\n  -natural-hpadding: 1px;\n}\n\n.space-bar-workspace-label.active {\n  margin: 0 2px;\n  background-color: rgba(0,0,0,0);\n  color: rgb(255,255,255);\n  border-color: rgba(0,0,0,0);\n  font-weight: 700;\n  border-radius: 32px;\n  border-width: 0px;\n  padding: 3px 8px;\n}\n\n.space-bar-workspace-label.inactive {\n  margin: 0 2px;\n  background-color: rgba(0,0,0,0);\n  color: rgba(255,255,255,0.6);\n  border-color: rgba(0,0,0,0);\n  font-weight: 700;\n  border-radius: 32px;\n  border-width: 0px;\n  padding: 3px 8px;\n}\n\n.space-bar-workspace-label.inactive.empty {\n  margin: 0 2px;\n  background-color: rgba(0,0,0,0);\n  color: rgba(255,255,255,0.4);\n  border-color: rgba(0,0,0,0);\n  font-weight: 700;\n  border-radius: 32px;\n  border-width: 0px;\n  padding: 3px 8px;\n}'"
dconf write /org/gnome/shell/extensions/space-bar/appearance/custom-styles "''"
dconf write /org/gnome/shell/extensions/space-bar/appearance/custom-styles-enabled "false"
dconf write /org/gnome/shell/extensions/space-bar/appearance/custom-styles-failed "false"
dconf write /org/gnome/shell/extensions/space-bar/appearance/empty-workspace-border-radius "32"
dconf write /org/gnome/shell/extensions/space-bar/appearance/empty-workspace-text-color "'rgba(255,255,255,0.4)'"
dconf write /org/gnome/shell/extensions/space-bar/appearance/inactive-workspace-border-radius "32"
dconf write /org/gnome/shell/extensions/space-bar/appearance/inactive-workspace-text-color "'rgba(255,255,255,0.6)'"
dconf write /org/gnome/shell/extensions/space-bar/appearance/workspace-margin "2"
dconf write /org/gnome/shell/extensions/space-bar/appearance/workspaces-bar-padding "1"
dconf write /org/gnome/shell/extensions/space-bar/behavior/always-show-numbers "false"
dconf write /org/gnome/shell/extensions/space-bar/behavior/indicator-style "'workspaces-bar'"
dconf write /org/gnome/shell/extensions/space-bar/behavior/scroll-wheel "'workspaces-bar'"
dconf write /org/gnome/shell/extensions/space-bar/behavior/scroll-wheel-wrap-around "true"
dconf write /org/gnome/shell/extensions/space-bar/behavior/show-empty-workspaces "true"
dconf write /org/gnome/shell/extensions/space-bar/behavior/toggle-overview "false"
dconf write /org/gnome/shell/extensions/space-bar/shortcuts/enable-activate-workspace-shortcuts "false"
dconf write /org/gnome/shell/extensions/space-bar/shortcuts/open-menu "@as []"

dconf write /org/gnome/shell/keybindings/open-new-window-application-1 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-2 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-3 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-4 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-5 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-6 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-7 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-8 "@as []"
dconf write /org/gnome/shell/keybindings/open-new-window-application-9 "@as []"
dconf write /org/gnome/shell/keybindings/screenshot "['Print']"
dconf write /org/gnome/shell/keybindings/screenshot-window "['<Super>Print']"
dconf write /org/gnome/shell/keybindings/show-screen-recording-ui "@as []"
dconf write /org/gnome/shell/keybindings/show-screenshot-ui "['<Shift>Print']"
dconf write /org/gnome/shell/keybindings/switch-to-application-1 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-2 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-3 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-4 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-5 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-6 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-7 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-8 "@as []"
dconf write /org/gnome/shell/keybindings/switch-to-application-9 "@as []"
dconf write /org/gnome/shell/keybindings/toggle-application-view "['<Super>d', '<Super>a']"
dconf write /org/gnome/shell/keybindings/toggle-overview "['<Shift><Super>o']"

dconf write /org/gnome/software/first-run "false"

dconf write /org/gnome/tweaks/show-extensions-notice "false"

dconf write /org/gtk/gtk4/settings/file-chooser/show-hidden "true"
dconf write /org/gtk/gtk4/settings/file-chooser/sort-directories-first "true"

dconf write /org/gtk/settings/file-chooser/clock-format "'24h'"
