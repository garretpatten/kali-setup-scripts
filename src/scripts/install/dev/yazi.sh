#!/bin/bash

if command -v yazi >/dev/null 2>&1; then
    exit 0
fi

deb="$TEMP_DIR/yazi-latest.deb"
curl -fsSL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.deb" -o "$deb" || exit 0

[ -s "$deb" ] || exit 0
if ! dpkg-deb -I "$deb" >/dev/null 2>&1; then
    exit 0
fi

sudo dpkg -i "$deb" || true
