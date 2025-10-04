#!/bin/bash

# =============================================================================
# Install Helium Browser (AppImage)
# =============================================================================

# download current AppImage
HELIUM_VERSION=$(curl -s "https://api.github.com/repos/imputnet/helium-linux/releases/latest" \
| grep -Po '"tag_name": "\K[^"]*')
mkdir -p $HOME/.local/applications
wget -qO $HOME/.local/applications/helium.AppImage \
https://github.com/imputnet/helium-linux/releases/download/0.4.12.1/helium-${HELIUM_VERSION}-x86_64.AppImage
chmod a+x $HOME/.local/applications/helium.AppImage

# add launch script with GTK environment variable
mkdir -p $HOME/.local/bin
printf '%s\n' '#!/bin/bash' '' 'bash -c "GDK_SCALE=1 $HOME/.local/applications/helium.AppImage"' \
> $HOME/.local/bin/helium-browser.sh
chmod +x $HOME/.local/bin/helium-browser.sh

# add .desktop file
mkdir -p $HOME/.local/share/applications
printf '%s\n' '[Desktop Entry]' 'Version=1.0' 'Name=Helium Browser' 'GenericName=Web Browser' \
'Comment=Access the Internet' 'StartupWMClass=helium-browser' 'Exec=bash -c "bash $HOME/.local/bin/helium-browser.sh"' \
'StartupNotify=true' 'Terminal=false' 'Icon=internet-web-browser' 'Type=Application' 'Categories=Network;WebBrowser;' \
'MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ipfs;x-scheme-handler/ipns;' \
> $HOME/.local/share/applications/helium-browser.desktop
