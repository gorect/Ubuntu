#!/bin/bash


MODULE="docker"

check_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo "docker already installed"
        return 0
    else
        echo "docker not installed"
        return 1
    fi
}

apply_docker() {
    echo "Installing Docker..."

    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg

    sudo install -m 0755 -d /etc/apt/keyrings

    if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    fi

    if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl enable --now docker

# Add the invoking (non-root) user to the docker group, not root itself
    local target_user="${SUDO_USER:-$USER}"

    if [[ -n "$target_user" && "$target_user" != "root" ]]; then
        if id -nG "$target_user" | grep -qw docker; then
            log "$target_user is already in the docker group"
        else
            sudo usermod -aG docker "$target_user"
            log "Added $target_user to the docker group (they must log out/in, or run 'newgrp docker', for it to take effect)"
        fi
    else
        log "No non-root invoking user detected — skipping docker group assignment"
    fi
}
