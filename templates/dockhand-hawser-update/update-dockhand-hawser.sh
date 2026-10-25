#!/usr/bin/env bash
# Managed by homelab.sh (module: dockhand_hawser_update). Edits here will be overwritten
# on the next provisioning run - change templates/dockhand-hawser-update/ in the repo instead.
#
# Finds every compose project that contains a Dockhand or Hawser container (matched by
# image name, so container/folder names like hawser150 don't matter) and refreshes it.
set -u
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Image repository names to match (the part after the last "/" and before the tag)
IMAGE_NAMES_REGEX='^(hawser|dockhand)$'

# Set to false to skip the host-wide dangling-image cleanup at the end
PRUNE_IMAGES=true

declare -A project_name config_files

while IFS='|' read -r id image; do
  repo="${image##*/}"
  repo="${repo%%[:@]*}"
  [[ "${repo,,}" =~ $IMAGE_NAMES_REGEX ]] || continue

  workdir=$(docker inspect "$id" --format '{{ index .Config.Labels "com.docker.compose.project.working_dir" }}')
  if [[ -z "$workdir" ]]; then
    echo "Skipping container $id ($image): not started with docker compose"
    continue
  fi

  project_name[$workdir]=$(docker inspect "$id" --format '{{ index .Config.Labels "com.docker.compose.project" }}')
  config_files[$workdir]=$(docker inspect "$id" --format '{{ index .Config.Labels "com.docker.compose.project.config_files" }}')
done < <(docker ps -a --format '{{.ID}}|{{.Image}}')

if [[ ${#project_name[@]} -eq 0 ]]; then
  echo "$(date '+%F %T') No Dockhand/Hawser compose projects found on this host"
fi

mapfile -t dirs < <(printf '%s\n' "${!project_name[@]}" | sort)

for dir in "${dirs[@]}"; do
  [[ -n "$dir" ]] || continue
  echo "=== $(date '+%F %T') Updating $dir (project ${project_name[$dir]}) ==="

  if [[ ! -d "$dir" ]]; then
    echo "Skipping: $dir does not exist"
    continue
  fi
  cd "$dir" || { echo "Cannot cd to $dir"; continue; }

  args=(-p "${project_name[$dir]}")
  IFS=',' read -ra files <<< "${config_files[$dir]}"
  for f in "${files[@]}"; do
    [[ -n "$f" ]] && args+=(-f "$f")
  done

  docker compose "${args[@]}" down \
    && docker compose "${args[@]}" pull \
    && docker compose "${args[@]}" up -d --force-recreate \
    || echo "FAILED: $dir"
done

if [[ "$PRUNE_IMAGES" == "true" ]]; then
  docker image prune -f
fi
