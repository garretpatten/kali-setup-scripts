#!/bin/bash

cliTools=("bat" "curl" "eza" "fd" "htop" "jq" "ripgrep" "vim" "wget")
for cliTool in "${cliTools[@]}"; do
    if [[ ! -f "/usr/bin/$cliTool" && ! -f "/usr/sbin/$cliTool" ]]; then
        sudo apt-get install "$cliTool" -y
    fi
done

# Fastfetch
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt-get update -y
sudo apt-get install fastfetch -y

### Package managers ###

# Flatpak
if [[ ! -f "/usr/bin/flatpak" ]]; then
    sudo apt-get install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
