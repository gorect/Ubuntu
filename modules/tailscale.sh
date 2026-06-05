#!/usr/bin/env bash

check_tailscale() {
    command -v tailscale >/dev/null 2>&1
}

apply_tailscale() {
    echo "Installing Tailscale..."

    curl -fsSL https://tailscale.com/install.sh | sh

    if ! command -v tailscale >/dev/null 2>&1; then
        echo "Tailscale installation failed"
        return 1
    fi

    echo "Tailscale installation successful"
}
