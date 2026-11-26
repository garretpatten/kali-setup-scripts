#!/usr/bin/env bash
# Shared config validation sections used by validate-config*.sh.
# Sourcing scripts are expected to source validate-common.sh first.

validate_config_dotfiles() {
    section 'Dotfiles'
    check_path zshrc "$HOME/.zshrc"
    check_path tmux-conf "$HOME/.config/tmux/tmux.conf"
    check_path vimrc "$HOME/.vimrc"
    check_path git-hooks-dir "$HOME/.config/githooks"
    check_path git-pre-commit "$HOME/.config/githooks/pre-commit"
}

validate_config_cooldown_configs() {
    section 'Package cooldown configs'
    check_path cooldown-npmrc "$HOME/.npmrc"
    check_path cooldown-pip-conf "$HOME/.config/pip/pip.conf"
    check_path cooldown-uv-toml "$HOME/.config/uv/uv.toml"
    check_path cooldown-cargo-config "$HOME/.cargo/config.toml"
    if grep -q 'min-release-age=7' "$HOME/.npmrc" 2>/dev/null; then
        pass cooldown-npmrc-age 'min-release-age=7 in ~/.npmrc'
    else
        fail cooldown-npmrc-age 'expected min-release-age=7 in ~/.npmrc'
    fi
    if grep -q 'uploaded-prior-to' "$HOME/.config/pip/pip.conf" 2>/dev/null; then
        pass cooldown-pip-age 'uploaded-prior-to in ~/.config/pip/pip.conf'
    else
        fail cooldown-pip-age 'expected uploaded-prior-to in ~/.config/pip/pip.conf'
    fi
    if grep -q 'exclude-newer' "$HOME/.config/uv/uv.toml" 2>/dev/null; then
        pass cooldown-uv-age 'exclude-newer in ~/.config/uv/uv.toml'
    else
        fail cooldown-uv-age 'expected exclude-newer in ~/.config/uv/uv.toml'
    fi
    if grep -q 'global-min-publish-age' "$HOME/.cargo/config.toml" 2>/dev/null; then
        pass cooldown-cargo-age 'global-min-publish-age in ~/.cargo/config.toml'
    else
        fail cooldown-cargo-age 'expected global-min-publish-age in ~/.cargo/config.toml'
    fi
}

validate_config_tmux() {
    section 'Tmux'
    check_path tmux-tpm "$HOME/.tmux/plugins/tpm/tpm"
    check_path tmux-plugin-resurrect "$HOME/.tmux/plugins/tmux-resurrect"
    check_path tmux-plugin-continuum "$HOME/.tmux/plugins/tmux-continuum"
}

validate_config_home() {
    section 'Home layout'
    check_path appimages-dir "$HOME/AppImages"
    check_path hacking-dir "$HOME/Hacking"
    check_path projects-dir "$HOME/Projects"
    check_path projects-personal "$HOME/Projects/personal"
    check_path projects-opensource "$HOME/Projects/opensource"
}

validate_config_git() {
    section 'Git'
    credential_helper="/usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret"
    if [[ -x "$credential_helper" ]]; then
        check_path git-credential-libsecret "$credential_helper"
        if git config --global --get credential.helper 2>/dev/null | grep -Fq "$credential_helper"; then
            pass git-credential-helper 'libsecret'
        else
            fail git-credential-helper "git config --global credential.helper $credential_helper"
        fi
    else
        if git config --global --get credential.helper 2>/dev/null | grep -Fq 'store'; then
            pass git-credential-helper 'store'
        else
            fail git-credential-helper 'git config --global credential.helper store'
        fi
    fi

    if git config --global --get core.hooksPath 2>/dev/null | grep -Fq "$HOME/.config/githooks"; then
        pass git-hooksPath "$HOME/.config/githooks"
    else
        fail git-hooksPath "git config --global core.hooksPath $HOME/.config/githooks"
    fi
}
