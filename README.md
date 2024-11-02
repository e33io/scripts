# scripts

custom Linux installation scripts

&nbsp;

## window managers and desktop environments

- use the scripts below with a [Debian minimal installation](https://e33.io/913)
	- use [`deb-post-install-options.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-options.sh) to run initial setup and select a WM or DE to install
	- use [`deb-post-install-i3.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-i3.sh) to [install the i3 window manager](https://e33.io/1121)
	- use [`deb-post-install-jwm.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-jwm.sh) to [install the JWM window manager](https://e33.io/1398)
	- use [`deb-post-install-xfce.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-xfce.sh) to [install the Xfce desktop environment](https://e33.io/1541)
	- use [`deb-post-install-lxqt.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-lxqt.sh) to [install the LXQt desktop environment](https://git.sr.ht/~e33io/reference-wiki/tree/main/item/installation-docs/debian-lxqt-installation.md)
	- use [`deb-post-install-cinnamon.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-cinnamon.sh) to [install the Cinnamon desktop environment](https://git.sr.ht/~e33io/reference-wiki/tree/main/item/installation-docs/debian-cinnamon-installation.md)
	- use [`deb-post-install-gnome.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/deb-post-install-gnome.sh) to [install the Gnome desktop environment](https://git.sr.ht/~e33io/reference-wiki/tree/main/item/installation-docs/debian-gnome-installation.md)

- use the script below with an Ubuntu 24.04 Server installation
	- use [`ubuntu-srvr-post-install-i3.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/ubuntu-srvr-post-install-i3.sh) to [install the i3 window manager](https://git.sr.ht/~e33io/reference-wiki/tree/main/item/installation-docs/ubuntu-i3-installation.md)

- use the script below with an [openSUSE "Generic Desktop" installation](https://git.sr.ht/~e33io/reference-wiki/tree/main/item/installation-docs/opensuse-generic-desktop-installation.md)
	- use [`opensuse-post-install-i3.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/opensuse-post-install-i3.sh) to [install the i3 window manager](https://git.sr.ht/~e33io/reference-wiki/tree/main/item/installation-docs/opensuse-i3-installation.md)

&nbsp;

## applications

- use [`install-brave-deb.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-brave-deb.sh) to install the [Brave Browser](https://brave.com) (apt package)

- use [`install-librewolf-deb.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-librewolf-deb.sh) to install the [LibreWolf Web Browser](https://librewolf.net) (.deb package)

- use [`install-signal-deb.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-signal-deb.sh) to install [Signal App](https://www.signal.org) (apt package)

- use [`install-firefox-deb.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-firefox-deb.sh) to install the [Firefox Web Browser](https://www.mozilla.org/en-US/firefox) (.deb package)

- use [`install-firefox.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-firefox.sh) to install the [Firefox Web Browser](https://www.mozilla.org/en-US/firefox) (tarball build)

- use [`install-thunderbird.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-thunderbird.sh) to install the [Thunderbird Email Client](https://www.thunderbird.net/en-US) (tarball build)

- use [`install-lazygit.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-lazygit.sh) to install [Lazygit](https://github.com/jesseduffield/lazygit) (tarball build)

&nbsp;

## theming

- use [`set-i3-theming.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/set-i3-theming.sh) to select and set theming for i3 and applications

- use [`set-jwm-theming.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/set-jwm-theming.sh) to select and set theming for JWM and applications

- use [`install-mint-themes.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-mint-themes.sh) to install Linux Mint themes and icons on Debian

- use [`install-mint-themes-suse.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-mint-themes-suse.sh) to install Linux Mint themes and icons on openSUSE

- use [`install-yaru-themes.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-yaru-themes.sh) to install Yaru themes and icons on Debian

- use [`install-yaru-themes-suse.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-yaru-themes-suse.sh) to install Yaru themes and icons on openSUSE

&nbsp;

## utilities

- use [`make-swap-file.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/make-swap-file.sh) to make and setup a swap file

- use [`setup-tearfree-amd.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/setup-tearfree-amd.sh) to setup TearFree for AMD GPUs

- use [`setup-tearfree-intel.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/setup-tearfree-intel.sh) to setup TearFree for Intel GPUs

- use [`laptop-wakelock-service.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/laptop-wakelock-service.sh) to add and enable wakelock service for laptops

- use [`gnome-install-nemo-deb.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/gnome-install-nemo-deb.sh) to replace Gnome Files App with Nemo on Debian

- use [`ubuntu-remove-snapd.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/ubuntu-remove-snapd.sh) to remove Snap and optionally install Flatpak on Ubuntu

- use [`install-flatpak-deb.sh`](https://git.sr.ht/~e33io/scripts/tree/main/item/install-flatpak-deb.sh) to install Flatpak and add Flathub on Debian

&nbsp;

## other/testing
- scripts in [`temp`](https://git.sr.ht/~e33io/scripts/tree/main/item/temp) directory are for testing purposes only

&nbsp;

## links
- view my documentation and notes [reference-wiki](https://git.sr.ht/~e33io/reference-wiki) repo

&nbsp;

### License
[BSD Zero Clause License](https://git.sr.ht/~e33io/scripts/tree/main/item/LICENSE)
