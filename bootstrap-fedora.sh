#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
source /etc/os-release
[[ $ID == fedora && ${VERSION_ID:-} == 44 ]] || { echo 'Target: Fedora 44 traditional (DNF), KDE recommended.' >&2; exit 1; }
[[ ! -e /run/ostree-booted ]] || { echo 'Atomic Fedora is not supported.' >&2; exit 1; }
(( EUID != 0 )) || { echo 'Run as your normal user, not root.' >&2; exit 1; }
# Repositories observed on the source PC. DNF retains its normal confirmation prompts.
sudo dnf install 'dnf-command(copr)' 'dnf-command(config-manager)' git stow
sudo dnf copr enable sdegler/hyprland
sudo dnf copr enable atim/starship
# Brave's official Fedora 41+ repository (DNF5), no downloaded installer script.
if [[ ! -f /etc/yum.repos.d/brave-browser.repo ]]; then
  sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
fi
mapfile -t packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' packages/fedora.txt)
sudo dnf install "${packages[@]}" brave-browser
git submodule update --init --recursive
# Build the exact Noctalia fork if absent; keep later ABI rebuilds explicit.
if ! command -v qs >/dev/null || ! qs --version 2>&1 | grep -q 'noctalia-qs'; then
  ./scripts/install-noctalia-qs-fedora.sh
fi
./scripts/install-fonts.sh
./install.sh
systemctl --user daemon-reload
./scripts/check-setup.sh
printf '%s\n' 'Al login seleziona: Hyprland (uwsm-managed).' 'Completa docs/MIGRATION.md per dati e componenti opzionali.' 'Shell predefinita (opzionale): chsh -s "$(command -v zsh)".'
