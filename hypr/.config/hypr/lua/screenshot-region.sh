#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"

case "$mode" in
  clipboard)
    geometry="$(/usr/bin/slurp)" || exit 0
    [ -n "$geometry" ] || exit 0
    /usr/bin/grim -g "$geometry" - | /usr/bin/wl-copy --type image/png
    ;;

  save)
    out_dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
    file_name="$(date +'%Y-%m-%d-%H%M%S_region.png')"
    out_file="$out_dir/$file_name"

    mkdir -p "$out_dir"
    geometry="$(/usr/bin/slurp)" || exit 0
    [ -n "$geometry" ] || exit 0

    /usr/bin/grim -g "$geometry" "$out_file"
    /usr/bin/wl-copy --type image/png < "$out_file"
    /usr/bin/notify-send "Screenshot salvato" "$out_file" -i "$out_file" -a Hyprshot
    ;;

  *)
    printf 'Usage: %s {clipboard|save}\n' "$0" >&2
    exit 2
    ;;
esac
