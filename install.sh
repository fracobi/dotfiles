#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "== Dotfiles install =="

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed."
  echo "Fedora: sudo dnf install stow"
  echo "Arch: sudo pacman -S stow"
  exit 1
fi

PACKAGES=(
  hypr
  kitty
  starship
  zsh
  fastfetch
  noctalia
  quickshell
  theming
)

for package in "${PACKAGES[@]}"; do
  if [ -d "$package" ]; then
    echo "Stowing $package..."
    stow "$package"
  else
    echo "Skipping $package: directory not found"
  fi
done

echo "Done."
