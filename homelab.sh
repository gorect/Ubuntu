#!/usr/bin/env bash

set -e

DRY_RUN=0
RUN_RESULTS=()

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

    echo "----------------------------------"
    echo "Module: $module"
    echo "----------------------------------"

    # -------------------------
    # DRY RUN MODE
    # -------------------------
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[DRY RUN] $module"

        if declare -f "$check_fn" >/dev/null; then
            if "$check_fn" >/dev/null 2>&1; then
                echo "Status: already configured"
            else
                echo "Status: would be installed/applied"
            fi
        else
            echo "Status: no check function"
        fi

        return 0
    fi

    # -------------------------
    # REAL RUN MODE
    # -------------------------

    # Step 1: check if already done
    if declare -f "$check_fn" >/dev/null; then
        if "$check_fn" >/dev/null 2>&1; then
            log "${module}: SKIP (already satisfied)"
            mark_done "$module"
            return 0
        fi
    fi

    # Step 2: apply
    if declare -f "$apply_fn" >/dev/null; then
        log "${module}: APPLY"
        "$apply_fn"
    else
        echo "[ERROR] Missing function: $apply_fn"
        return 1
    fi

    # Step 3: verify after apply
    if declare -f "$check_fn" >/dev/null; then
        if "$check_fn" >/dev/null 2>&1; then
            mark_done "$module"
            log "${module}: OK"
        else
            echo "[ERROR] $module failed verification"
            return 1
        fi
    else
        # fallback if no check exists
        mark_done "$module"
        log "$module marked complete (no verification available)"
    fi
}

install_base() {
    log "Installing base system..."

    # Leave these commented until converted
    # run_module prereqs

    run_module qemu
    run_module prereqs
    run_module tailscale
    run_module bashrc
    run_module unattended
}

install_docker_host() {
    install_base
    run_module docker
}

install_ai_server() {
    install_base
    run_module docker
    run_module scaletail_ai

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
