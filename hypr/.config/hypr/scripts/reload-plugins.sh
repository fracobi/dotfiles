#!/usr/bin/env bash
set -euo pipefail
# Query hyprpm itself: its storage path varies between releases.
if hyprpm list 2>/dev/null | grep -q 'enabled:.*true'; then
  sleep 5
  hyprpm reload -n
fi
