#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../../lib/env.sh
source "$DIR/../../lib/env.sh"
# shellcheck source=../../lib/apt-repo-add.sh
source "$DIR/../../lib/apt-repo-add.sh"

manifest="$DIR/manifest"
pids=()

while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// /}" ]] && continue

    (
        IFS='|' read -r kind _rest <<< "$line"
        case "$kind" in
            repo|wget)
                IFS='|' read -r _ key_url keyring_path list_path grep_pattern deb_line <<< "$line"
                setup_repo_from_manifest_line "$kind" "$key_url" "$keyring_path" "$list_path" "$grep_pattern" "$deb_line"
                ;;
            bruno|nodesource)
                setup_repo_from_manifest_line "$kind"
                ;;
        esac
    ) &
    pids+=($!)
done < "$manifest"

for pid in "${pids[@]}"; do
    wait "$pid" || true
done

# Remove the now-defunct griffo repo (subscription-only since 1 Oct 2026) if present.
sudo rm -f /etc/apt/sources.list.d/debian.griffo.io.list \
    /etc/apt/trusted.gpg.d/debian.griffo.io.gpg 2>/dev/null || true
