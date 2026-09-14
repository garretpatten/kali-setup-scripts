#!/bin/bash

# Ghostty is not in Kali's or Debian's repos. Install the Debian amd64 .deb
# built by mkasberg/ghostty-ubuntu. Release tag "1.3.1-0-ppa2" maps to the
# asset version "1.3.1-0.ppa2" (dashes become dots in the asset name).

if command -v ghostty >/dev/null 2>&1; then
    exit 0
fi

tag="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/mkasberg/ghostty-ubuntu/releases/latest | sed 's|.*/tag/||')"
version="${tag%-*}.${tag##*-}"

if [[ -z "$version" ]]; then
    exit 0
fi

deb="$TEMP_DIR/ghostty-amd64-trixie.deb"
curl -fsSL "https://github.com/mkasberg/ghostty-ubuntu/releases/download/${tag}/ghostty_${version}_amd64_trixie.deb" -o "$deb" || exit 0

[ -s "$deb" ] || exit 0
if ! dpkg-deb -I "$deb" >/dev/null 2>&1; then
    exit 0
fi

sudo dpkg -i "$deb" || true
sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y || true
