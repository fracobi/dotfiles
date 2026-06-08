#!/usr/bin/env bash

# Durata del pre-lock countdown
COUNTDOWN=10

# Se Spotify/browser/video stanno suonando, non mostrare nulla
if playerctl --ignore-player=spotify status 2>/dev/null | grep -q Playing; then
    exit 0
fi

notify-send \
    -r 9998 \
    -u critical \
    "Blocco schermo imminente" \
    "Lo schermo verrà bloccato tra ${COUNTDOWN} secondi. Muovi il mouse o premi un tasto per annullare."

sleep "$COUNTDOWN"
