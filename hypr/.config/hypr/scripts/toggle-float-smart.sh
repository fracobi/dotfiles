#!/usr/bin/env bash

set -euo pipefail

LOG="/tmp/toggle-float-smart.log"

# Evita che il log diagnostico cresca senza limiti.
if [[ -f "$LOG" ]] && (( $(stat -c %s "$LOG") > 1048576 )); then
  : > "$LOG"
fi

printf '%s\n' "---- $(date) ----" >> "$LOG"

SIZE_W=1200
SIZE_H=750

lua_dispatch() {
  hyprctl dispatch "$1" >> "$LOG" 2>&1
}

ACTIVE_JSON="$(hyprctl activewindow -j 2>>"$LOG")"
ACTIVE_WS_ID="$(hyprctl activeworkspace -j 2>>"$LOG" | jq -er '.id')"
CLIENTS_JSON="$(hyprctl clients -j 2>>"$LOG")"

WINDOW_COUNT="$(jq -er --argjson workspace_id "$ACTIVE_WS_ID" \
  '[.[] | select(.workspace.id == $workspace_id)] | length' <<< "$CLIENTS_JSON")"

IS_FLOATING="$(jq -er 'if .floating then 1 else 0 end' <<< "$ACTIVE_JSON")"

echo "WINDOW_COUNT=$WINDOW_COUNT" >> "$LOG"
echo "IS_FLOATING=$IS_FLOATING" >> "$LOG"

if [[ "$WINDOW_COUNT" == "0" ]]; then
  echo "No active window" >> "$LOG"
  exit 0
fi

if [[ "$IS_FLOATING" == "1" ]]; then
  echo "Already floating -> toggle tiled" >> "$LOG"
  lua_dispatch 'hl.dsp.window.float({ action = "toggle" })'
  exit 0
fi

if [[ "$WINDOW_COUNT" == "1" ]]; then
  echo "Only one window -> float resize center" >> "$LOG"
  lua_dispatch 'hl.dsp.window.float({ action = "toggle" })'
  lua_dispatch "hl.dsp.window.resize({ x = $SIZE_W, y = $SIZE_H, relative = false })"
  lua_dispatch 'hl.dsp.window.center()'
else
  echo "Multiple windows -> only float" >> "$LOG"
  lua_dispatch 'hl.dsp.window.float({ action = "toggle" })'
fi
