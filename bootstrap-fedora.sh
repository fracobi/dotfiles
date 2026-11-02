#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
source /etc/os-release
[[ $ID == fedora && ${VERSION_ID:-} == 44 ]] || { echo 'Target: Fedora 44 traditional (DNF), KDE recommended.' >&2; exit 1; }
[[ ! -e /run/ostree-booted ]] || { echo 'Atomic Fedora is not supported.' >&2; exit 1; }
(( EUID != 0 )) || { echo 'Run as your normal user, not root.' >&2; exit 1; }
# Repositories observed on the source PC. DNF retains its normal confirmation prompts.
sudo dnf install 'dnf-command(copr)' git stow
sudo dnf copr enable sdegler/hyprland
sudo dnf copr enable errornointernet/quickshell
mapfile -t packages < <(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' packages/fedora.txt)
sudo dnf install "${packages[@]}"
git submodule update --init --recursive
# Do not silently substitute stock Quickshell for the currently used Noctalia fork.
if ! command -v qs >/dev/null || ! qs --version 2>&1 | grep -q 'noctalia-qs'; then
  echo 'BLOCKED: install the compatible noctalia-qs build first; see docs/REPLICATION.md.' >&2
  echo 'Dotfiles have not been applied.' >&2
  exit 1
fi
./install.sh
systemctl --user daemon-reload
printf '%s\n' 'Review docs/REPLICATION.md before selecting Hyprland at login.' 'Default shell: chsh -s "$(command -v zsh)" (optional).'
