#!/usr/bin/env bash

MODULE="bashrc"

target_home() {
    local target_user="${SUDO_USER:-$USER}"
    getent passwd "$target_user" | cut -d: -f6
}

check_bashrc() {
    local home
    home="$(target_home)"

    cmp -s \
        "$BASE_DIR/templates/dotfiles/.bashrc" \
        "$home/.bashrc"
}

apply_bashrc() {
    log "Installing .bashrc"

    local target_user="${SUDO_USER:-$USER}"
    local home
    home="$(target_home)"

    if [[ -f "$home/.bashrc" ]]; then
        cp \
            "$home/.bashrc" \
            "$home/.bashrc.bak.$(date +%Y%m%d-%H%M%S)"
    fi

    cp \
        "$BASE_DIR/templates/dotfiles/.bashrc" \
        "$home/.bashrc"

    # cp as root creates the file owned by root — fix ownership back to the real user
    if [[ "$target_user" != "root" ]]; then
        chown "$target_user:$target_user" "$home/.bashrc"
    fi
}
