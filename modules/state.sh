#!/usr/bin/env bash

STATE_DIR="/var/lib/homelab-state"

ensure_state_dir() {
    mkdir -p "$STATE_DIR"
}

is_done() {
    ensure_state_dir
    [[ -f "$STATE_DIR/$1" ]]
}

mark_done() {
    ensure_state_dir
    touch "$STATE_DIR/$1"
}

list_state() {
    ensure_state_dir

    echo "=============================="
    echo " Homelab State Summary"
    echo "=============================="
    echo

    local modules=(
        prereqs
        docker
        tailscale
        qemu
        ansible
        unattended
        go
        xcaddy
        bashrc
        dpkg
        networking
    )

    for mod in "${modules[@]}"; do
        if is_done "$mod"; then
            printf "✔ %-15s installed\n" "$mod"
        else
            printf "✖ %-15s not installed\n" "$mod"
        fi
    done

    echo
    echo "State directory: $STATE_DIR"
}

# Optional helper (kept but renamed for clarity)
not_done() {
    ! is_done "$1"
}
