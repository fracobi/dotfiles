#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"
case "$direction" in
  prev|next) ;;
  *) exit 2 ;;
esac

monitor_state="$(hyprctl -j monitors)"

monitor="$(
  jq -r '.[] | select(.focused == true) | .name' <<< "$monitor_state"
)"

current="$(
  jq -r '.[] | select(.focused == true) | .activeWorkspace.id' <<< "$monitor_state"
)"

[[ -n "$monitor" && "$monitor" != "null" ]] || exit 0
[[ "$current" =~ ^[0-9]+$ ]] || exit 0

mapfile -t workspaces < <(
  hyprctl -j workspaces |
    jq -r --arg monitor "$monitor" \
      '[.[] | select(.monitor == $monitor and .id > 0) | .id] | sort | .[]'
)

target=""

for i in "${!workspaces[@]}"; do
  if [[ "${workspaces[$i]}" == "$current" ]]; then
    if [[ "$direction" == "prev" && "$i" -gt 0 ]]; then
      target="${workspaces[$((i - 1))]}"
    elif [[ "$direction" == "next" && "$i" -lt $((${#workspaces[@]} - 1)) ]]; then
      target="${workspaces[$((i + 1))]}"
    fi
    break
  fi
done

[[ -n "$target" ]] || exit 0
hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = "'"$target"'", on_current_monitor = true }))' >/dev/null
