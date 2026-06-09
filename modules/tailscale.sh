#!/usr/bin/env bash

MODULE="tailscale"

check_tailscale() {
    command -v tailscale >/dev/null 2>&1
}

apply_tailscale() {
    log "Installing Tailscale"

    curl -fsSL https://tailscale.com/install.sh | sh
}
