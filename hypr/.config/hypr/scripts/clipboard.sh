#!/bin/bash

selection=$(cliphist list | rofi -dmenu \
  -theme ~/.config/rofi/launchers/type-1/style-5.rasi \
  -p "📋 ")

[ -z "$selection" ] && exit 0

echo "$selection" | cliphist decode | wl-copy
