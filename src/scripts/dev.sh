#!/bin/bash

source "$(pwd)/src/scripts/utils.sh"

### Apt repositories ###

setup_apt_repos() {
    # Brave
    if [[ ! -f /usr/share/keyrings/brave-browser-archive-keyring.gpg ]]; then
        curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
            | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg >/dev/null || true
    fi
    if ! grep -q brave-browser-apt-release /etc/apt/sources.list.d/*.list 2>/dev/null; then
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" \
            | sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null || true
    fi

    # Docker
    if [[ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]]; then
        curl -fsSL https://download.docker.com/linux/debian/gpg \
            | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg || true
    fi
    if ! grep -q download.docker.com /etc/apt/sources.list.d/*.list 2>/dev/null; then
        arch=$(dpkg --print-architecture)
        codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
        echo "deb [arch=${arch} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian ${codename} stable" \
            | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null || true
    fi

    # Signal
    if [[ ! -f /usr/share/keyrings/signal-desktop-keyring.gpg ]]; then
        curl -fsSL https://updates.signal.org/desktop/apt/keys.asc \
            | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg || true
    fi
    if ! grep -q updates.signal.org /etc/apt/sources.list.d/*.list 2>/dev/null; then
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" \
            | sudo tee /etc/apt/sources.list.d/signal-xenial.list >/dev/null || true
    fi

    # NodeSource
    if [[ ! -f /etc/apt/keyrings/nodesource.gpg ]]; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
            | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg || true
    fi
    if ! grep -q deb.nodesource.com /etc/apt/sources.list.d/*.list 2>/dev/null; then
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_24.x nodistro main" \
            | sudo tee /etc/apt/sources.list.d/nodesource.list >/dev/null || true
    fi

    # Bruno
    if [[ ! -f /etc/apt/keyrings/bruno.gpg ]]; then
        curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9FA6017ECABE0266" \
            | sudo gpg --dearmor -o /etc/apt/keyrings/bruno.gpg || true
        sudo chmod 644 /etc/apt/keyrings/bruno.gpg 2>/dev/null || true
    fi
    if ! grep -q debian.usebruno.com /etc/apt/sources.list.d/*.list 2>/dev/null; then
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/ bruno stable" \
            | sudo tee /etc/apt/sources.list.d/bruno.list >/dev/null || true
    fi

    # Griffo
    if [[ ! -f /etc/apt/trusted.gpg.d/debian.griffo.io.gpg ]]; then
        curl -fsSL https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc \
            | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg || true
    fi
    if ! grep -q debian.griffo.io /etc/apt/sources.list.d/*.list 2>/dev/null; then
        codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
        echo "deb https://debian.griffo.io/apt ${codename} main" \
            | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list >/dev/null || true
    fi

    sudo apt-get update -y || true
}

setup_apt_repos

### Apt packages ###

install_apt() {
    for pkg in "$@"; do
        if dpkg -s "$pkg" >/dev/null 2>&1; then
            continue
        fi
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$pkg" || {
            echo "Failed to install ${pkg}." >> "$ERROR_FILE"
        }
    done
}

# CLI, security, and general tools
install_apt \
    bat btop eza fd-find fzf flatpak gcc gh htop jq make \
    libimage-exiftool-perl libsecret-1-0 libsecret-1-dev nmap openvpn \
    pkg-config ripgrep shellcheck snapd tealdeer tree-sitter-cli ufw \
    unattended-upgrades unzip vim whois wget zoxide

# Shell
install_apt \
    fonts-font-awesome fonts-firacode tmux zsh zsh-autosuggestions zsh-syntax-highlighting

# Media
install_apt ffmpeg vlc

# Desktop
install_apt gnome-shell-extensions gnome-tweaks

# Productivity
install_apt \
    flameshot keepassxc libreoffice libreoffice-gtk3 libreoffice-style-breeze redshift

# Dev
install_apt \
    neovim python3 python3-dev python3-neovim python3-pip python3-venv

# Language servers / dev runtimes
install_apt \
    build-essential composer default-jdk-headless golang-go gzip liblua5.4-dev \
    luarocks lua5.4 php-cli php-mbstring php-xml php-zip ruby-dev ruby-full tar

# Optional desktop
install_apt \
    fonts-powerline gstreamer1.0-libav gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly powerline

# Third-party apt packages
install_apt \
    brave-browser bruno containerd.io docker-ce docker-ce-cli docker-compose-plugin \
    gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator \
    libayatana-appindicator3-1 nodejs signal-desktop

# Griffo tools
install_apt lazydocker lazygit yazi

# Optional language runtime
install_apt julia

### Runtimes ###

# Node Version Manager
if [[ ! -d "$HOME/.nvm" ]]; then
    # nosemgrep: bash.curl.security.curl-pipe-bash.curl-pipe-bash Installation comes from upstream nvm docs
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash || true
fi

# Rustup
if [[ ! -f "$HOME/.cargo/env" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || true
fi

# Ollama
if ! is_installed ollama; then
    curl -fsSL https://ollama.com/install.sh | sh || true
fi

### Dev tools ###

# Docker service
if is_installed docker; then
    sudo systemctl enable docker.service || true
    sudo systemctl start docker.service || true
    sudo usermod -aG docker "$USER" || true
fi

# Global npm packages
if is_installed npm; then
    sudo npm install -g bash-language-server pyright typescript-language-server yaml-language-server \
        @vue/cli --loglevel=error --no-update-notifier || true
fi

# Semgrep
pip3 install --user semgrep || true

# Ruby gems
if is_installed gem; then
    gem install --user-install solargraph || true
fi

# Lua language server
if ! is_installed lua-language-server; then
    latest_url=$(curl -sL -o /dev/null -w '%{url_effective}' --connect-timeout 10 --max-time 30 \
        https://github.com/LuaLS/lua-language-server/releases/latest 2>/dev/null)
    lls_version=${latest_url##*/}
    if [[ -n "$lls_version" ]]; then
        lls_tar="/tmp/lua-language-server-${lls_version}-linux-x64.tar.gz"
        if curl -fsSL --connect-timeout 30 --max-time 300 \
            "https://github.com/LuaLS/lua-language-server/releases/download/${lls_version}/lua-language-server-${lls_version}-linux-x64.tar.gz" \
            -o "$lls_tar" 2>/dev/null; then
            lls_install_dir="$HOME/.local/share/lua-language-server"
            mkdir -p "$lls_install_dir"
            tar -xzf "$lls_tar" -C "$lls_install_dir" || true
            if [[ -f "$lls_install_dir/bin/lua-language-server" ]]; then
                mkdir -p "$HOME/.local/bin"
                cat > "$HOME/.local/bin/lua-language-server" <<EOF
#!/bin/bash
exec "$lls_install_dir/bin/lua-language-server" "\$@"
EOF
                chmod +x "$HOME/.local/bin/lua-language-server" || true
            fi
        fi
    fi
fi

# Cursor CLI
curl -fsSL https://cursor.com/install | bash || true

# git-credential-libsecret
credential_src="/usr/share/doc/git/contrib/credential/libsecret"
credential_bin="$credential_src/git-credential-libsecret"
if [[ -d "$credential_src" && ! -x "$credential_bin" ]]; then
    if dpkg -s libsecret-1-dev >/dev/null 2>&1; then
        (cd "$credential_src" && sudo make) || true
    fi
fi

# Etcher
if ! is_installed balena-etcher && ! dpkg -s balena-etcher >/dev/null 2>&1; then
    etcher_deb="/tmp/balena-etcher.deb"
    etcher_tag=$(curl -fsSL https://api.github.com/repos/balena-io/etcher/releases/latest 2>/dev/null | \
        grep '"tag_name"' | head -1 | cut -d '"' -f 4)
    etcher_tag="${etcher_tag:-v2.1.6}"
    etcher_version="${etcher_tag#v}"
    etcher_url="https://github.com/balena-io/etcher/releases/download/${etcher_tag}/balena-etcher_${etcher_version}_amd64.deb"
    if curl -fsSL --retry 3 --retry-delay 2 "$etcher_url" -o "$etcher_deb" 2>/dev/null; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$etcher_deb" || true
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y --no-install-recommends || true
    fi
fi

# Proton Pass
if ! is_installed proton-pass && ! dpkg -s proton-pass >/dev/null 2>&1; then
    proton_pass_deb="/tmp/proton-pass.deb"
    json_path="/tmp/proton-pass-version.json"
    if curl -fsSL --retry 3 --retry-delay 2 -A "Mozilla/5.0 (X11; Linux x86_64)" \
        "https://proton.me/download/pass/linux/version.json" -o "$json_path" 2>/dev/null; then
        deb_url=$(grep -oE 'https://[^"]+proton-pass_[^"]*_amd64\.deb' "$json_path" | head -1)
        if [[ -n "$deb_url" ]] && curl -fsSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 2 \
            -A "Mozilla/5.0 (X11; Linux x86_64)" "$deb_url" -o "$proton_pass_deb" 2>/dev/null; then
            sudo dpkg -i "$proton_pass_deb" || true
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -f -y --no-install-recommends || true
        fi
    fi
fi

if ! is_installed pass-cli; then
    proton_pass_cli="/tmp/pass-cli"
    proton_pass_cli_arch="x86_64"
    case "$(uname -m)" in
        aarch64 | arm64) proton_pass_cli_arch="aarch64" ;;
    esac
    proton_pass_cli_url="https://github.com/protonpass/pass-cli/releases/latest/download/pass-cli-linux-${proton_pass_cli_arch}"
    if curl -fsSL --retry 3 --retry-delay 2 "$proton_pass_cli_url" -o "$proton_pass_cli" 2>/dev/null; then
        if [[ -s "$proton_pass_cli" ]] && [[ "$(head -c 4 "$proton_pass_cli" 2>/dev/null)" == $'\x7fELF' ]]; then
            chmod +x "$proton_pass_cli"
            sudo install -m 755 "$proton_pass_cli" /usr/local/bin/pass-cli
        fi
    fi
fi

# ufw-docker
if [[ ! -x /usr/local/bin/ufw-docker ]]; then
    sudo wget -q -O /usr/local/bin/ufw-docker \
        https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker || true
    sudo chmod +x /usr/local/bin/ufw-docker || true
fi

# Ghostty
if ! is_installed ghostty; then
    install_script="/tmp/ghostty-ubuntu-install.sh"
    curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh -o "$install_script" 2>/dev/null || true
    if [[ -f "$install_script" ]]; then
        sudo bash "$install_script" || true
    fi
fi

# Meslo Nerd Font
font_dir="/usr/share/fonts/meslo-nerd-font"
if [[ ! -d "$font_dir" ]]; then
    temp_font_dir="/tmp/meslo-font"
    mkdir -p "$temp_font_dir"
    meslo_zip="$temp_font_dir/Meslo.zip"
    if curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip -o "$meslo_zip" 2>/dev/null; then
        sudo mkdir -p "$font_dir"
        unzip -q "$meslo_zip" -d "$temp_font_dir" || true
        sudo mv "$temp_font_dir"/*.ttf "$font_dir/" 2>/dev/null || true
        sudo mv "$temp_font_dir"/*.otf "$font_dir/" 2>/dev/null || true
        fc-cache -fv || true
    fi
fi

# Oh My Posh
if ! is_installed oh-my-posh; then
    install_dir="$HOME/.local/bin"
    install_script="/tmp/oh-my-posh-install.sh"
    mkdir -p "$install_dir"
    curl -fsSL https://ohmyposh.dev/install.sh -o "$install_script" 2>/dev/null || true
    if [[ -f "$install_script" ]]; then
        bash "$install_script" -d "$install_dir" 2>/dev/null || true
    fi
fi

# Snap packages (best-effort; snapd may not be enabled on all Kali installs)
if is_installed snap && ! snap list zoom-client >/dev/null 2>&1; then
    sudo snap install zoom-client || true
fi

### Dotfiles and configuration ###

# Home directory layout
mkdir -p "$HOME/AppImages" "$HOME/Hacking" "$HOME/Projects/opensource" "$HOME/Projects/personal"
if [[ -d "$HOME/Scripts" ]]; then
    chmod 755 "$HOME/Scripts" || true
fi
if [[ -d "$HOME/Hacking" ]]; then
    chmod 700 "$HOME/Hacking" || true
fi

# Git config
credential_helper="/usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret"
if [[ -x "$credential_helper" ]]; then
    git config --global credential.helper "$credential_helper"
else
    git config --global credential.helper store
fi

if ! git config --global core.hooksPath >/dev/null 2>&1; then
    git config --global core.hooksPath "$HOME/.config/githooks"
fi

if [[ ! -f "$HOME/.gitconfig" ]]; then
    git config --global http.postBuffer 157286400
    git config --global pack.window 1
    git config --global user.email "garret.patten@proton.me"
    git config --global user.name "Garret Patten"
    git config --global pull.rebase false
    git config --global init.defaultBranch main
fi

# Shared Git pre-commit hook
if [[ ! -f "$HOME/.config/githooks/pre-commit" ]]; then
    mkdir -p "$HOME/.config/githooks/"
    cp "$(pwd)/src/dotfiles/config/githooks/pre-commit" "$HOME/.config/githooks/pre-commit" || {
        echo "Failed to configure Git pre-commit hook." >> "$ERROR_FILE"
    }
    chmod +x "$HOME/.config/githooks/pre-commit" || true
fi

# XDG config directory symlinks
dotfiles_root="$(pwd)/src/dotfiles"
config_src="$dotfiles_root/config"
xdg="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$xdg"

if [[ -d "$config_src" ]]; then
    shopt -s nullglob
    for dir in "$config_src"/*/; do
        [[ -d "$dir" ]] || continue
        name=$(basename "${dir%/}")
        src_abs=$(cd "${dir%/}" && pwd)
        target="${xdg}/${name}"

        if [[ -e "$target" || -L "$target" ]] && [[ ! -L "$target" ]]; then
            bak="${target}.dotfiles-bak-$(date +%Y%m%d%H%M%S)"
            printf '%s exists; moving to %s\n' "$target" "$bak" >&2
            mv "$target" "$bak" || true
        fi

        if [[ "$(readlink "$target" 2>/dev/null)" == "$src_abs" ]]; then
            continue
        fi

        ln -sfn "$src_abs" "$target"
    done
    shopt -u nullglob
fi

# Dotfiles file copies
copy_dotfile() {
    local rel_src="$1"
    local dest="$2"
    local src="$dotfiles_root/$rel_src"

    [[ -f "$dest" ]] && return 0
    mkdir -p "$(dirname "$dest")"
    [[ -f "$src" ]] && cp "$src" "$dest"
}

copy_dotfile "home/.vimrc" "$HOME/.vimrc"
copy_dotfile "vs-code/settings.json" "$HOME/.config/Code/User/settings.json"
copy_dotfile "home/.tmux.conf" "$HOME/.tmux.conf"
copy_dotfile "home/.zshrc" "$HOME/.zshrc"
copy_dotfile "home/.bashrc" "$HOME/.bashrc"

# TLDR cache update
if is_installed tldr; then
    tldr --update || true
fi

# Semgrep rules cache (best-effort)
if is_installed semgrep; then
    semgrep --version >/dev/null 2>&1 || true
fi
