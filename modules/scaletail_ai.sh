#!/usr/bin/env bash

MODULE="scaletail_ai"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$BASE_DIR/common.sh"
source "$BASE_DIR/state.sh"

REPO_URL="https://github.com/tailscale-dev/ScaleTail.git"
BASE_PATH="/opt/docker/scaletail"

OLLAMA_SRC="$BASE_PATH/services/ollama"
WEBUI_SRC="$BASE_PATH/services/open-webui"

OLLAMA_DST="/opt/docker/ollama"
WEBUI_DST="/opt/docker/open-webui"

# -------------------------
# CHECK
# -------------------------
check_scaletail_ai() {
    docker ps --format '{{.Names}}' | grep -q "app-ollama" && \
    docker ps --format '{{.Names}}' | grep -q "app-open-webui"
}

# -------------------------
# CLONE REPO (idempotent)
# -------------------------
ensure_repo() {
    if [[ ! -d "$BASE_PATH/.git" ]]; then
        log "Cloning ScaleTail repo into $BASE_PATH"
        sudo git clone "$REPO_URL" "$BASE_PATH"
    else
        log "ScaleTail repo already exists, pulling latest"
        sudo git -C "$BASE_PATH" pull
    fi
}

# -------------------------
# DEPLOY SERVICE
# -------------------------
deploy_service() {
    local src="$1"
    local dst="$2"
    local service="$3"

    sudo mkdir -p "$dst"

    log "Deploying $service"

    # copy compose + env if present
    [[ -f "$src/docker-compose.yml" ]] && sudo cp "$src/docker-compose.yml" "$dst/"
    [[ -f "$src/.env" ]] && sudo cp "$src/.env" "$dst/.env"

    # ensure data dirs exist
    sudo mkdir -p "$dst/data" "$dst/config" "$dst/ts/state"

    # ensure docker compose works
    sudo docker compose -f "$dst/docker-compose.yml" up -d
}

# -------------------------
# APPLY
# -------------------------
apply_scaletail_ai() {
    log "Deploying ScaleTail AI stack from upstream repo"

    ensure_repo

    deploy_service "$OLLAMA_SRC" "$OLLAMA_DST" "ollama"
    deploy_service "$WEBUI_SRC" "$WEBUI_DST" "open-webui"
}

# -------------------------
# MAIN
# -------------------------
main() {
    require_root

    if is_done "$MODULE"; then
        log "ScaleTail AI already configured"
        return 0
    fi

    apply_scaletail_ai

    if check_scaletail_ai; then
        mark_done "$MODULE"
        log "ScaleTail AI stack deployed successfully"
    else
        echo "[ERROR] ScaleTail AI verification failed"
        exit 1
    fi
}

main "$@"
