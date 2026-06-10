#!/usr/bin/env bash

MODULE="unattended"

check_unattended() {
    dpkg -s unattended-upgrades >/dev/null 2>&1 &&
    cmp -s \
        "$BASE_DIR/templates/unattended-upgrades/20auto-upgrades" \
        /etc/apt/apt.conf.d/20auto-upgrades &&
    cmp -s \
        "$BASE_DIR/templates/unattended-upgrades/50unattended-upgrades" \
        /etc/apt/apt.conf.d/50unattended-upgrades
}

apply_unattended() {
    log "Installing unattended-upgrades"

    apt-get update -y
    apt-get install -y unattended-upgrades

    install -m 644 \
        "$BASE_DIR/templates/unattended-upgrades/20auto-upgrades" \
        /etc/apt/apt.conf.d/20auto-upgrades

    install -m 644 \
        "$BASE_DIR/templates/unattended-upgrades/50unattended-upgrades" \
        /etc/apt/apt.conf.d/50unattended-upgrades

    systemctl restart unattended-upgrades.service 2>/dev/null || true
}

