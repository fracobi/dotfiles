#!/usr/bin/env bash
set -euo pipefail

monitor_state="$(hyprctl -j monitors)"
primary="$(jq -r '([.[] | select(.name == "eDP-1")][0] // [.[] | select(.focused)][0] // .[0]).name // empty' <<< "$monitor_state")"
[[ -n "$primary" ]] || exit 0
has_hdmi="$(
  jq -e '.[] | select(.name == "HDMI-A-1")' <<< "$monitor_state" >/dev/null && echo 1 || echo 0
)"

# Keep the original dual-monitor split only when both distinct outputs exist.
if [[ "$has_hdmi" == "1" && "$primary" != "HDMI-A-1" ]]; then
  mapfile -t existing < <(
    hyprctl -j workspaces | jq -r '.[] | select(.id >= 1 and .id <= 10) | .id'
  )

  for ws in "${existing[@]}"; do
    if (( ws >= 1 && ws <= 5 )); then
      hyprctl eval 'hl.dispatch(hl.dsp.workspace.move({ workspace = "'"$ws"'", monitor = "HDMI-A-1" }))' >/dev/null
    else
      hyprctl eval 'hl.dispatch(hl.dsp.workspace.move({ workspace = "'"$ws"'", monitor = "'"$primary"'" }))' >/dev/null
    fi
  done

  hyprctl eval 'hl.dispatch(hl.dsp.focus({ monitor = "'"$primary"'" }))' >/dev/null
  hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = "6", on_current_monitor = true }))' >/dev/null
  hyprctl eval 'hl.dispatch(hl.dsp.focus({ monitor = "HDMI-A-1" }))' >/dev/null
  hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = "1", on_current_monitor = true }))' >/dev/null
else
  mapfile -t existing < <(
    hyprctl -j workspaces | jq -r '.[] | select(.id >= 1 and .id <= 10) | .id'
  )

  for ws in "${existing[@]}"; do
    hyprctl eval 'hl.dispatch(hl.dsp.workspace.move({ workspace = "'"$ws"'", monitor = "'"$primary"'" }))' >/dev/null
  done

  hyprctl eval 'hl.dispatch(hl.dsp.focus({ monitor = "'"$primary"'" }))' >/dev/null
  hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = "1", on_current_monitor = true }))' >/dev/null
fi
