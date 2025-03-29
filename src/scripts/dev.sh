#!/bin/bash

source "$(pwd)/src/scripts/utils.sh"

### Runtimes ###

# Node, npm, and nvm
if [[ "$packageManager" = "apt-get" ]]; then
    # nosemgrep: bash.curl.security.curl-pipe-bash.curl-pipe-bash Installation comes from Debian docs
    curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -
    sudo apt-get install nodejs -y
    # nosemgrep: bash.curl.security.curl-pipe-bash.curl-pipe-bash Installation comes from Debian docs
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi

# Python and pip
if [[ ! -f "/usr/bin/python" || ! -f "usr/bin/python3" ]]; then
    sudo apt-get install python3.6 -y
    sudo apt-get install python3-pip -y
fi

### Dev Tools ###

# Docker and Docker-Compose
if ! is_installed "docker"; then
    sudo apt-get update -y
    sudo apt-get install apt-transport-https ca-certificates software-properties-common -y
    sudo apt-get install docker.io -y

    sudo apt-get install docker-compose -y
    docker image pull archlinux
    docker image pull fedora
fi

# GitHub CLI
if ! is_installed "gh"; then
    sudo apt-get install gh -y
fi

# Neovim
if ! is_installed "nvim"; then
    sudo apt-get install nvim -y
fi

# Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" || {
    echo "Failed to clone https://github.com/wbthomason/packer.nvim" >> "$ERROR_FILE";
}

# Postman
if [[ ! -d "/var/lib/flatpak/app/com.getpostman.Postman" ]]; then
    flatpak install flathub com.getpostman.Postman -y
fi

# Semgrep
if ! is_installed "semgrep"; then
    python -m pip install semgrep
fi

# Shellcheck
if ! is_installed "shellcheck"; then
    sudo apt-get install shellcheck -y
fi

### Configuration ###

# Git
if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global credential.helper store
    git config --global http.postBuffer 157286400
    git config --global pack.window 1
    git config --global user.email "garret.patten@proton.me"
    git config --global user.name "Garret Patten"
    git config --global pull.rebase false
fi

# Neovim
if [[ ! -d "$HOME/.config/nvim/" ]]; then
    mkdir -p "$HOME/.config/nvim/"
    cp -r "$(pwd)/src/dotfiles/nvim/" "$HOME/.config/nvim/" || {
        echo "Failed to configure Neovim." >> "$ERROR_FILE";
    }
fi

# Vim
if [[ ! -f "$HOME/.vimrc" ]]; then
    cp "$(pwd)/src/dotfiles/vim/.vimrc" "$HOME/.vimrc" || {
        echo "Failed to configure Vim." >> "$ERROR_FILE";
    }
fi
