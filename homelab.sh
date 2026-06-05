#!/usr/bin/env bash

set -e

DRY_RUN=0

EXCLUDED_MODULES=(
    common
    state
)

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            ;;
    esac
done

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASE_DIR/modules/common.sh"
source "$BASE_DIR/modules/state.sh"

require_root

echo "=================================="
echo "   Ubuntu Homelab Installer"
echo "=================================="
echo

if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "***** DRY RUN MODE *****"
    echo "No changes will be made."
    echo
fi

load_module() {
    local module="$1"
    local file="$BASE_DIR/modules/${module}.sh"

    if [[ ! -f "$file" ]]; then
        echo "[ERROR] Module not found: $module"
        return 1
    fi

    source "$file"
}

run_module() {
    local module="$1"

    load_module "$module"

    local check_fn="check_${module}"
    local apply_fn="apply_${module}"

    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[DRY RUN] ${module}"

        if declare -f "$check_fn" >/dev/null; then
            if "$check_fn"; then
                echo "  Status: already configured"
            else
                echo "  Status: needs installation/configuration"
            fi
        else
            echo "  (no preflight check available)"
        fi

        return 0
    fi

    if declare -f "$check_fn" >/dev/null; then
        if "$check_fn" >/dev/null 2>&1; then
            log "${module} already configured"
            mark_done "$module"
            return 0
        fi
    fi

    if declare -f "$apply_fn" >/dev/null; then
        "$apply_fn"

        if declare -f "$check_fn" >/dev/null; then
            if "$check_fn" >/dev/null 2>&1; then
                mark_done "$module"
                log "${module} setup complete"
            else
                echo "[ERROR] ${module} failed verification"
                return 1
            fi
        fi
    else
        echo "[ERROR] Missing function: ${apply_fn}"
        return 1
    fi
}

install_base() {
    log "Installing base system..."

    # Leave these commented until converted
    # run_module prereqs

    run_module qemu
    run_module tailscale

    # run_module unattended
}

install_docker_host() {
    install_base
    run_module docker
}

install_ai_server() {
    install_docker_host

    # Leave commented until converted
    # run_module go
    # run_module xcaddy
}

echo "What are you setting up?"
echo "1) Base server (minimal tools)"
echo "2) Docker host"
echo "3) AI server (Docker + tooling)"
echo "4) Custom (choose modules manually)"
echo "5) Show state"
echo

read -rp "Selection: " PROFILE

case "$PROFILE" in
    1)
        install_base
        ;;
    2)
        install_docker_host
        ;;
    3)
        install_ai_server
        ;;
    4)
    echo
    echo "Available modules:"

    find "$BASE_DIR/modules" -maxdepth 1 -name "*.sh" \
        ! -name "common.sh" \
        ! -name "state.sh" \
        -printf "%f\n" \
        | sed 's/\.sh$//' \
        | sort

    echo

	read -rp "Module: " mod
	run_module "$mod"
	;;
    5)
        list_state
        ;;
    *)
        echo "Invalid selection"
        exit 1
        ;;
esac

echo
echo "Done."
