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

# Language servers for opencode
if command -v npm >/dev/null 2>&1; then
    sudo npm install -g bash-language-server pyright typescript-language-server yaml-language-server 2>>"$ERROR_FILE" || true
fi

if ! is_installed "lua-language-server"; then
    latest_url=$(curl -sL -o /dev/null -w '%{url_effective}' --connect-timeout 10 --max-time 30 \
        https://github.com/LuaLS/lua-language-server/releases/latest 2>>"$ERROR_FILE")
    lls_version=${latest_url##*/}
    if [[ -n "$lls_version" ]]; then
        lls_tar="/tmp/lua-language-server-${lls_version}-linux-x64.tar.gz"
        if curl -fsSL --connect-timeout 30 --max-time 300 \
            "https://github.com/LuaLS/lua-language-server/releases/download/${lls_version}/lua-language-server-${lls_version}-linux-x64.tar.gz" \
            -o "$lls_tar" 2>>"$ERROR_FILE"; then
            lls_install_dir="$HOME/.local/share/lua-language-server"
            mkdir -p "$lls_install_dir"
            tar -xzf "$lls_tar" -C "$lls_install_dir" 2>>"$ERROR_FILE" || true
            if [[ -f "$lls_install_dir/bin/lua-language-server" ]]; then
                mkdir -p "$HOME/.local/bin"
                cat > "$HOME/.local/bin/lua-language-server" <<EOF
#!/bin/bash
exec "$lls_install_dir/bin/lua-language-server" "\$@"
EOF
                chmod +x "$HOME/.local/bin/lua-language-server" 2>>"$ERROR_FILE" || true
            fi
        fi
    fi
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

# Shared Git pre-commit hook
if [[ ! -d "$HOME/.config/githooks" ]]; then
    mkdir -p "$HOME/.config/githooks/"
    cp "$(pwd)/src/dotfiles/config/githooks/pre-commit" "$HOME/.config/githooks/pre-commit" || {
        echo "Failed to configure Git pre-commit hook." >> "$ERROR_FILE";
    }
    chmod +x "$HOME/.config/githooks/pre-commit" || true
fi
if ! git config --global core.hooksPath >/dev/null 2>&1; then
    git config --global core.hooksPath "$HOME/.config/githooks" || {
        echo "Failed to configure Git hooks path." >> "$ERROR_FILE";
    }
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
