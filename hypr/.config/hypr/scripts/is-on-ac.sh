#!/usr/bin/env bash

if [ "$(cat /sys/class/power_supply/ADP1/online 2>/dev/null)" = "1" ]; then
    exit 0
fi

exit 1
