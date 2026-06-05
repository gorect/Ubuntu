#!/usr/bin/env bash

check_qemu() {
    systemctl is-enabled qemu-guest-agent >/dev/null 2>&1 &&
    systemctl is-active qemu-guest-agent >/dev/null 2>&1
}

apply_qemu() {
    echo "Installing QEMU Guest Agent..."

    apt-get update -qq
    apt-get install -y qemu-guest-agent

    echo "Enabling and starting QEMU Guest Agent..."

    systemctl enable --now qemu-guest-agent

    echo "QEMU Guest Agent installed and running successfully!"
}
