#!/usr/bin/env bash

MODULE="scaletail_ai"

REPO_URL="https://github.com/tailscale-dev/ScaleTail.git"
BASE_PATH="/opt/docker/scaletail"

OLLAMA_PATH="$BASE_PATH/services/ollama"
WEBUI_PATH="$BASE_PATH/services/open-webui"

# -------------------------
# CHECK
# -------------------------
check_scaletail_ai() {
    docker ps --format '{{.Names}}' | grep -q ollama && \
    docker ps --format '{{.Names}}' | grep -q open-webui
}

# -------------------------
# REPO SYNC
# -------------------------
ensure_repo() {
    if [[ ! -d "$BASE_PATH/.git" ]]; then
        log "Cloning ScaleTail repo"
        sudo git clone "$REPO_URL" "$BASE_PATH"
    else
        log "Updating ScaleTail repo"
        sudo git -C "$BASE_PATH" pull
    fi
}

# -------------------------
# DEPLOY
# -------------------------
deploy_service() {
    local src="$1"
    local dst="$2"
    local name="$3"

    log "Deploying $name"

    sudo mkdir -p "$dst"

    if [[ -f "$src/docker-compose.yml" ]]; then
        sudo cp "$src/docker-compose.yml" "$dst/"
    else
        echo "[ERROR] Missing compose file for $name"
        return 1
    fi

    if [[ -f "$src/.env" ]]; then
        sudo cp "$src/.env" "$dst/"
    fi

    cd "$dst" || return 1
    sudo docker compose up -d
}

# -------------------------
# APPLY
# -------------------------
apply_scaletail_ai() {
    log "Deploying ScaleTail AI stack"

    ensure_repo || return 1

    deploy_service "$OLLAMA_PATH" "$BASE_PATH/ollama" "ollama" || return 1
    deploy_service "$WEBUI_PATH" "$BASE_PATH/open-webui" "open-webui" || return 1
}

