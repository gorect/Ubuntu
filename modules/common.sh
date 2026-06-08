#!/bin/bash

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Please run as root"
        exit 1
    fi
}

check_ubuntu() {
    source /etc/os-release

    if [[ "$ID" != "ubuntu" ]]; then
        echo "Ubuntu required"
        exit 1
    fi
}

log() {
    echo "[INFO] $1"
}
