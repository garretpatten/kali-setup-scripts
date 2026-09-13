#!/bin/bash

if command -v lazydocker >/dev/null 2>&1; then
    exit 0
fi

tag="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/jesseduffield/lazydocker/releases/latest | sed 's|.*/tag/||')"
version="${tag#v}"

if [[ -z "$version" ]]; then
    exit 0
fi

tarball="$TEMP_DIR/lazydocker.tar.gz"
curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/${tag}/lazydocker_${version}_Linux_x86_64.tar.gz" -o "$tarball" || exit 0

install_dir="$TEMP_DIR/lazydocker-install"
rm -rf "$install_dir"
mkdir -p "$install_dir"
tar -xzf "$tarball" -C "$install_dir" || exit 0

[ -f "$install_dir/lazydocker" ] || exit 0
sudo install -m 755 "$install_dir/lazydocker" /usr/local/bin/lazydocker || true
