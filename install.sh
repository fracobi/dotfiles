#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
REPO="$PWD"
DRY_RUN=0
if [[ ${1:-} == --dry-run ]]; then DRY_RUN=1; shift; fi
TARGET_DIR="${1:-$HOME}"
[[ -d "$TARGET_DIR" ]] || { echo "Target directory does not exist" >&2; exit 1; }
TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
command -v stow >/dev/null || { echo 'Install GNU Stow first.' >&2; exit 1; }
PACKAGES=(hypr kitty starship zsh brave fastfetch noctalia quickshell theming desktop local-bin)
# Back up individual conflicts only: never move all of ~/.config/systemd/user.
if (( DRY_RUN )); then
  stow --simulate --verbose --no-folding --target="$TARGET_DIR" "${PACKAGES[@]}"
  exit
fi
BACKUP="$TARGET_DIR/.local/state/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
for package in "${PACKAGES[@]}"; do
  while IFS= read -r -d '' source; do
    relative="${source#"$package/"}"
    target="$TARGET_DIR/$relative"
    # A link already pointing at this source is managed, including folded directories.
    [[ $(readlink -f "$target" 2>/dev/null || true) == "$REPO/$source" ]] && continue
    parent="$(dirname "$target")"
    while [[ "$parent" != "$TARGET_DIR" ]]; do
      if [[ -L "$parent" || ( -e "$parent" && ! -d "$parent" ) ]]; then
        echo "Refusing obstructing parent: $parent" >&2; exit 1
      fi
      parent="$(dirname "$parent")"
    done
    if [[ -e "$target" || -L "$target" ]]; then
      mkdir -p "$BACKUP/$(dirname "$relative")"
      mv -- "$target" "$BACKUP/$relative"
      echo "Backup: $BACKUP/$relative"
    fi
  done < <(find "$package" \( -name .git -o -name .github \) -prune -o \( -type f -o -type l \) ! -name '*.bak' ! -name '*.bak-*' ! -name '*.backup-*' ! -name '*.save' ! -name '*.save.*' -print0)
done
stow --no-folding --target="$TARGET_DIR" "${PACKAGES[@]}"
echo 'Dotfiles installed. Services are not automatically enabled or started.'
