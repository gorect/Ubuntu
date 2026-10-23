#!/usr/bin/env bash

MODULE="dockhand_hawser_update"

AU_TEMPLATE_DIR="$BASE_DIR/templates/dockhand-hawser-update"
AU_SCRIPT="/opt/docker/update-dockhand-hawser.sh"
AU_CRON="/etc/cron.d/dockhand-hawser-update"        # no dots in the name or cron ignores it
AU_LOGROTATE="/etc/logrotate.d/dockhand-hawser-update"

# -------------------------
# CHECK
# -------------------------
check_dockhand_hawser_update() {
    cmp -s "$AU_TEMPLATE_DIR/update-dockhand-hawser.sh"       "$AU_SCRIPT" &&
    cmp -s "$AU_TEMPLATE_DIR/dockhand-hawser-update.cron"      "$AU_CRON" &&
    cmp -s "$AU_TEMPLATE_DIR/dockhand-hawser-update.logrotate" "$AU_LOGROTATE"
}

# -------------------------
# APPLY
# -------------------------
apply_dockhand_hawser_update() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "[ERROR] docker is not installed - run the docker module first"
        return 1
    fi

    log "Installing Dockhand/Hawser update script, cron job, and logrotate config"

    install -d -m 755 "$(dirname "$AU_SCRIPT")"
    install -m 755 "$AU_TEMPLATE_DIR/update-dockhand-hawser.sh"       "$AU_SCRIPT"
    install -m 644 "$AU_TEMPLATE_DIR/dockhand-hawser-update.cron"      "$AU_CRON"
    install -m 644 "$AU_TEMPLATE_DIR/dockhand-hawser-update.logrotate" "$AU_LOGROTATE"

    log "Daily update scheduled for 04:00 (log: /var/log/dockhand-hawser-update.log)"
}
