#!/bin/bash

# Brave
if [[ ! -f "/usr/bin/brave-browser" ]]; then
    curl -fsS https://dl.brave.com/install.sh | sh
fi

# Google Chrome
if [[ ! -f "/usr/bin/google-chrome" ]] && ! dpkg -s google-chrome-stable >/dev/null 2>&1; then
    chrome_deb="/tmp/google-chrome-stable.deb"
    curl -fsSL --retry 3 --retry-delay 2 "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "$chrome_deb" || true
    if [[ -f "$chrome_deb" ]] && [[ -s "$chrome_deb" ]]; then
        sudo dpkg -i "$chrome_deb" || true
        sudo apt-get install -f -y || true
    fi
fi

# Spotify
if [[ ! -d "/usr/bin/spotify-launcher" ]]; then
    sudo apt-get install spotify-launcher -y
fi

# VLC
if [[ ! -f "/usr/bin/vlc" ]]; then
    sudo apt-get install vlc -y
fi
