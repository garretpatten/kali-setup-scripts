#!/usr/bin/env bash
# Shared config validation sections used by validate-config*.sh.
# Sourcing scripts are expected to source validate-common.sh first.

validate_config_dotfiles() {
    section 'Dotfiles'
    check_path zshrc "$HOME/.zshrc"
    check_path tmux-conf "$HOME/.tmux.conf"
    check_path vimrc "$HOME/.vimrc"
    check_path git-hooks-dir "$HOME/.config/githooks"
    check_path git-pre-commit "$HOME/.config/githooks/pre-commit"
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
