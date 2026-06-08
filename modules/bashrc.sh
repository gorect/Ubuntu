#!/usr/bin/env bash

MODULE="bashrc"

check_bashrc() {
    cmp -s \
        "$BASE_DIR/templates/dotfiles/.bashrc" \
        "$HOME/.bashrc"
}

apply_bashrc() {
    log "Installing .bashrc"

    if [[ -f "$HOME/.bashrc" ]]; then
        cp \
            "$HOME/.bashrc" \
            "$HOME/.bashrc.bak.$(date +%Y%m%d-%H%M%S)"
    fi

    cp \
        "$BASE_DIR/templates/dotfiles/.bashrc" \
        "$HOME/.bashrc"
}
