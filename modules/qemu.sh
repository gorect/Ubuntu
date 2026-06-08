#!/usr/bin/env bash

MODULE="qemu"

check_qemu() {
    systemctl is-enabled qemu-guest-agent >/dev/null 2>&1 &&
    systemctl is-active qemu-guest-agent >/dev/null 2>&1
}

apply_qemu() {
    log "Installing QEMU Guest Agent"

    apt-get update -qq
    apt-get install -y qemu-guest-agent

    systemctl enable --now qemu-guest-agent

    log "QEMU Guest Agent installed successfully"
}
