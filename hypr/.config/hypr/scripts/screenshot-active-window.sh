#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
FILE_NAME="$(date +'%Y-%m-%d-%H%M%S_active-window.png')"
OUT_FILE="$OUT_DIR/$FILE_NAME"

mkdir -p "$OUT_DIR"

GEOMETRY="$(
  hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
)"

grim -g "$GEOMETRY" "$OUT_FILE"
wl-copy --type image/png < "$OUT_FILE"
notify-send "Screenshot salvato" "$OUT_FILE" -i "$OUT_FILE" -a Hyprshot
