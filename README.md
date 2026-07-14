# Ubuntu

A repository for maintaining Ubuntu Server modules for first time server setup or reprovisioning. The centerpiece is `homelab.sh`, a modular installer that quickly bootstraps a fresh Ubuntu box into a homelab-ready host.

## Contents

- **`homelab.sh`** — Interactive, module-based installer for setting up a new Ubuntu machine (base server, Docker host, or AI server profile)
- **`modules/`** — Individual, idempotent setup modules (check/apply pattern) sourced by `homelab.sh`
- **`tools/`** — Standalone one-off utility scripts (not part of the module system)
- **`templates/`** — Config files (dotfiles, unattended-upgrades) deployed by the modules
- **`ideas/`** — Scratch notes and script drafts not yet promoted into `modules/` or `tools/`
- **`Archive/`** — Older, superseded scripts from previous Ubuntu versions and machines, kept for reference

## Quick start

```bash
git clone https://github.com/gorect/Ubuntu.git
cd Ubuntu
sudo ./homelab.sh
```

You'll be prompted to choose a setup profile:

1. **Base server** — minimal tooling (QEMU guest agent, prereqs, Tailscale, bashrc, unattended-upgrades)
2. **Docker host** — everything in Base, plus Docker
3. **AI server** — everything in Docker host, plus the ScaleTail (Ollama + Open WebUI) stack
4. **Custom** — pick and run an individual module by name
5. **Show state** — list which modules have already been applied on this machine

Modules are idempotent: each one checks whether it's already satisfied before applying anything, and re-running `homelab.sh` will skip steps that are already done. Applied state is tracked in `/var/lib/homelab-state`.

Add `--dry-run` to preview what a profile would do without making any changes:

```bash
sudo ./homelab.sh --dry-run
```

## Modules

| Module | Purpose |
|---|---|
| `prereqs` | Installs baseline CLI tools (curl, git, wget, vim, htop, net-tools, etc.) |
| `qemu` | Installs and starts the QEMU guest agent (for VMs) |
| `tailscale` | Installs Tailscale |
| `bashrc` | Deploys the repo's `.bashrc` template |
| `unattended` | Installs and configures `unattended-upgrades` |
| `docker` | Installs Docker and verifies the invoking user is in the `docker` group |
| `scaletail_ai` | Deploys the ScaleTail (Ollama + Open WebUI) Docker stack |
| `common` / `state` | Shared helpers — root check, OS check, logging, and state tracking (excluded from the module menu) |

## Tools

Standalone scripts you can run directly, independent of the installer:

- **`tools/networking.sh`** — Updates the IP address, gateway, and nameservers in `/etc/netplan/50-cloud-init.yaml`
- **`tools/dpkg-repairs.sh`** — Re-runs `apt -f install` to fix a package that failed to install cleanly

## Archive

`Archive/` holds earlier, version-specific scripts (Ubuntu Desktop 20.04/24.04, Server 20.04/22.04/24.04, a MacBook Pro Qtile setup, and shared "Common-Files") from before the `homelab.sh` module system existed. These are kept for reference rather than active use — check `modules/` and `tools/` first for the current, maintained equivalents.

## Requirements

- Ubuntu (checked via `/etc/os-release`)
- Root privileges (`sudo`)

## License

See [LICENSE](LICENSE).
