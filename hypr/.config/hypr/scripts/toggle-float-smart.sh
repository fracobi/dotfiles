#!/usr/bin/env bash

LOG="/tmp/toggle-float-smart.log"

echo "---- $(date) ----" >> "$LOG"

SIZE_W=1200
SIZE_H=750

lua_dispatch() {
  hyprctl dispatch "$1" >> "$LOG" 2>&1
}

ACTIVE_JSON="$(hyprctl activewindow -j 2>>"$LOG")"
WORKSPACE_JSON="$(hyprctl activeworkspace -j 2>>"$LOG")"
CLIENTS_JSON="$(hyprctl clients -j 2>>"$LOG")"

WINDOW_COUNT="$(python - <<PY
import json

workspace = json.loads("""$WORKSPACE_JSON""")
clients = json.loads("""$CLIENTS_JSON""")

active_ws_id = workspace.get("id")
count = 0

for c in clients:
    ws = c.get("workspace", {})
    if ws.get("id") == active_ws_id:
        count += 1

print(count)
PY
)"

IS_FLOATING="$(python - <<PY
import json
active = json.loads("""$ACTIVE_JSON""")
print(1 if active.get("floating") else 0)
PY
)"

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
