#!/usr/bin/env bash

dir="$1"

case "$dir" in
  l|left)
    layout_dir="l"
    monitor_dir="l"
    ;;
  r|right)
    layout_dir="r"
    monitor_dir="r"
    ;;
  *)
    exit 1
    ;;
esac

before="$(hyprctl activewindow -j | jq -r '.address // empty')"

hyprctl eval 'hl.dispatch(hl.dsp.layout("focus '"$layout_dir"'"))' >/dev/null 2>&1

after="$(hyprctl activewindow -j | jq -r '.address // empty')"

if [ -n "$before" ] && [ "$before" = "$after" ]; then
  hyprctl eval 'hl.dispatch(hl.dsp.focus({ monitor = "'"$monitor_dir"'" }))' >/dev/null 2>&1
fi
