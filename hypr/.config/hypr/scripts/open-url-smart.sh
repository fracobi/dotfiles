#!/usr/bin/env bash

set -euo pipefail

URL="${1:-}"
BROWSER="${BROWSER_CMD:-brave-browser}"

if [[ -z "$URL" ]]; then
    echo "Uso: open-url-smart.sh <url>"
    exit 1
fi

# Workspace attuale
CURRENT_WS="$(hyprctl activeworkspace -j | jq -r '.id')"

# Cerca una finestra browser nel workspace attuale
# Modifica il regex delle classi in base al tuo browser, se serve
BROWSER_ADDR="$(
    hyprctl clients -j | jq -r --argjson ws "$CURRENT_WS" '
        map(
            select(
                .workspace.id == $ws and
                (
                    (.class | test("^(brave-browser|google-chrome|chromium|chromium|firefox|Firefox)$"; "i"))
                )
            )
        )
        | .[0].address // empty
    '
)"

if [[ -n "$BROWSER_ADDR" ]]; then
    # Focus sulla finestra browser del workspace corrente
    hyprctl dispatch focuswindow "address:$BROWSER_ADDR" >/dev/null

    # Piccola pausa per dare tempo al focus
    sleep 0.15

    # Prova ad aprire la URL nella finestra attiva/browser corrente
    "$BROWSER" "$URL" >/dev/null 2>&1 &
else
    # Nessun browser su questo workspace: nuova finestra
    "$BROWSER" --new-window "$URL" >/dev/null 2>&1 &
fi
