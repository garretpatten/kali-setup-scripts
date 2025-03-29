#!/bin/bash

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
if [[ "$packageManager" = "apt-get" ]]; then
    sudo apt-get update -y
    sudo apt-get install apt-transport-https ca-certificates software-properties-common -y
    sudo apt-get install docker.io -y

    sudo apt-get install docker-compose -y
    docker image pull archlinux
    docker image pull fedora
fi

# GitHub CLI
if [[ ! -f "/usr/local/bin/gh" ]]; then
    sudo apt install gh -y
fi

# Postman
if [[ "$packageManager" = "dnf" ]]; then
    flatpak install flathub com.getpostman.Postman -y
fi

# Semgrep
if [[ ! -f "$HOME/.local/bin/semgrep" ]]; then
    python -m pip install semgrep
fi

# Shellcheck
sudo apt install shellcheck -y

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

# TODO: Add vim config

# TODO: Add nvim config
