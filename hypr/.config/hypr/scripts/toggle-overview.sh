#!/usr/bin/env bash
set -euo pipefail
if hyprctl plugin list | grep -q '^Plugin scrolloverview '; then
  hyprctl eval 'hl.dispatch(hl.plugin.scrolloverview.overview("toggle all"))'
else
  exec qs ipc -c overview call overview toggle
fi
