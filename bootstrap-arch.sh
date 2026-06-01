#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "== Arch/CachyOS bootstrap =="

if ! command -v pacman >/dev/null 2>&1; then
  echo "This bootstrap script is intended for Arch-based systems."
  exit 1
fi

echo "== Updating system =="
sudo pacman -Syu --needed

echo "== Installing pacman packages =="
sudo pacman -S --needed - < packages/arch.txt

if ! command -v paru >/dev/null 2>&1; then
  echo "== Installing paru AUR helper =="
  sudo pacman -S --needed base-devel git

  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  cd "$tmpdir/paru"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
fi

echo "== Installing AUR packages =="
if [ -f packages/aur.txt ]; then
  paru -S --needed - < packages/aur.txt
fi

echo "== Applying dotfiles =="
./install.sh

echo "== Done =="
echo "You may need to log out and log back in."
