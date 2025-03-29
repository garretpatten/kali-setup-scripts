#!/bin/bash

cliTools=("alacritty" "bat" "curl" "exa" "eza" "fd" "htop" "jq" "neovim" "openvpn" "ripgrep" "terminator" "tmux" "vim" "wget")
for cliTool in "${cliTools[@]}"; do
    if [[ ! -f "/usr/bin/$cliTool" && ! -f "/usr/sbin/$cliTool" ]]; then
        sudo apt install "$cliTool" -y
    fi
done

# fastfetch
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt update 
sudo apt install fastfetch -y

### Package managers ###

# Flatpak
if [[ ! -f "/usr/bin/flatpak" ]]; then
    sudo apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
