#!/bin/bash
# 1Password desktop app and CLI (Kali-specific).

if command -v 1password >/dev/null 2>&1 && command -v op >/dev/null 2>&1; then
    exit 0
fi

onepassword_dir="/opt/1Password"
if [[ ! -d "$onepassword_dir" ]]; then
    onepassword_tar="$TEMP_DIR/1password-latest.tar.gz"
    if curl -fsSL --retry 3 --retry-delay 2 \
        https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz \
        -o "$onepassword_tar"; then
        sudo mkdir -p "$onepassword_dir"
        sudo tar -xf "$onepassword_tar" -C "$onepassword_dir" --strip-components=1 || true
        if [[ -x "$onepassword_dir/after-install.sh" ]]; then
            sudo "$onepassword_dir/after-install.sh" || true
        fi
    fi
fi

# 1Password CLI apt repository
keyring="/usr/share/keyrings/1password-archive-keyring.gpg"
if [[ ! -f "$keyring" ]]; then
    curl -fsSL https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output "$keyring" || true
fi

list_path="/etc/apt/sources.list.d/1password.list"
if [[ ! -f "$list_path" ]]; then
    arch="$(dpkg --print-architecture)"
    echo "deb [arch=${arch} signed-by=${keyring}] https://downloads.1password.com/linux/debian/${arch} stable main" | \
        sudo tee "$list_path" >/dev/null || true
fi

policy_dir="/etc/debsig/policies/AC2D62742012EA22"
if [[ ! -f "$policy_dir/1password.pol" ]]; then
    sudo mkdir -p "$policy_dir"
    curl -fsSL https://downloads.1password.com/linux/debian/debsig/1password.pol | \
        sudo tee "$policy_dir/1password.pol" >/dev/null || true
fi

keyring_dir="/usr/share/debsig/keyrings/AC2D62742012EA22"
if [[ ! -f "$keyring_dir/debsig.gpg" ]]; then
    sudo mkdir -p "$keyring_dir"
    curl -fsSL https://downloads.1password.com/linux/keys/1password.asc | \
        sudo gpg --dearmor --output "$keyring_dir/debsig.gpg" || true
fi

sudo apt-get update -y || true
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends 1password-cli || true
