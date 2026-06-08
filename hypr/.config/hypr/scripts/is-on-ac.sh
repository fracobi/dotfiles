#!/usr/bin/env bash

for ac in /sys/class/power_supply/*/online; do
    if [ "$(cat "$ac" 2>/dev/null)" = "1" ]; then
        exit 0
    fi
done

exit 1
