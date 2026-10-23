#!/usr/bin/env bash
# Managed by homelab.sh (module: dockhand_hawser_update). Edits here will be overwritten
# on the next provisioning run - change templates/dockhand-hawser-update/ in the repo instead.
set -u
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Compose project directories to refresh (the stacks that can't update themselves)
DIRS=(
  "/opt/docker/dockhand"
  "/opt/docker/hawser"
)

for dir in "${DIRS[@]}"; do
  echo "=== $(date '+%F %T') Updating $dir ==="

  if [[ ! -d "$dir" ]]; then
    echo "Skipping: $dir does not exist"
    continue
  fi

  cd "$dir" || { echo "Cannot cd to $dir"; continue; }

  docker compose down \
    && docker compose pull \
    && docker compose up -d --force-recreate \
    || echo "FAILED: $dir"
done

# Clean up old images left behind by the pulls
docker image prune -f
