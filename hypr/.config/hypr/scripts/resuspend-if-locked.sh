#!/usr/bin/env bash

# Evita più timer duplicati se il PC viene sospeso/risvegliato più volte
(
    flock -n 9 || exit 0

    # Tempo dopo il resume prima di sospendere di nuovo
    sleep 30

    # Se hyprlock è ancora attivo, vuol dire che non hai fatto login
    if pidof hyprlock >/dev/null; then
        systemctl suspend
    fi

) 9>/tmp/hypridle-resuspend.lock
