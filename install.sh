#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

TARGET_DIR="${1:-$HOME}"

echo "== Dotfiles install =="
echo "Target: $TARGET_DIR"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is not installed."
  echo "Fedora: sudo dnf install stow"
  echo "Arch: sudo pacman -S stow"
  exit 1
fi

backup_if_real_path() {
  local path="$1"

  if [ -e "$path" ] && [ ! -L "$path" ]; then
    local backup="${path}.backup-before-stow"

    echo "Backing up existing path:"
    echo "  $path -> $backup"

    if [ -e "$backup" ]; then
      backup="${path}.backup-before-stow.$(date +%Y%m%d-%H%M%S)"
      echo "Backup already exists, using:"
      echo "  $backup"
    fi

    mv "$path" "$backup"
  fi
}

backup_if_real_path "$TARGET_DIR/.zshrc"
backup_if_real_path "$TARGET_DIR/.config/hypr"
backup_if_real_path "$TARGET_DIR/.config/kitty"
backup_if_real_path "$TARGET_DIR/.config/fastfetch"
backup_if_real_path "$TARGET_DIR/.config/noctalia"
backup_if_real_path "$TARGET_DIR/.config/quickshell"
backup_if_real_path "$TARGET_DIR/.config/gtk-3.0"
backup_if_real_path "$TARGET_DIR/.config/Kvantum"

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
    stow -t "$TARGET_DIR" "$package"
  else
    echo "Skipping $package: directory not found"
  fi
done

echo "Done."
