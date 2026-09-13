#!/bin/bash

# Ghostty is not in Kali's or Debian's repos. Install the Debian amd64 .deb
# built by mkasberg/ghostty-ubuntu (forky build is closest to Kali rolling).

if command -v ghostty >/dev/null 2>&1; then
    exit 0
fi

tag="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/mkasberg/ghostty-ubuntu/releases/latest | sed 's|.*/tag/||')"
version="${tag#v}"

if [[ -z "$version" ]]; then
    exit 0
fi

deb="$TEMP_DIR/ghostty-amd64-forky.deb"
curl -fsSL "https://github.com/mkasberg/ghostty-ubuntu/releases/download/${tag}/ghostty_${version}_amd64_forky.deb" -o "$deb" || exit 0

[ -s "$deb" ] || exit 0
if ! dpkg-deb -I "$deb" >/dev/null 2>&1; then
    exit 0
fi

sudo dpkg -i "$deb" || true
sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y || true
