#!/usr/bin/env bash
set -uo pipefail
missing=0
for cmd in hyprland hyprctl hyprpm qs kitty zsh starship atuin zoxide fzf eza bat jq grim slurp wl-copy dbus-monitor dbus-update-activation-environment cliphist brightnessctl playerctl wpctl hyprlock hypridle brave-browser matugen spf wvkbd-mobintl; do
  command -v "$cmd" >/dev/null || { echo "MISSING command: $cmd"; missing=1; }
done
[[ -x /usr/libexec/hyprpolkitagent ]] || command -v hyprpolkitagent >/dev/null || { echo 'MISSING polkit agent'; missing=1; }
for file in "$HOME/.local/share/whisper.cpp/build/bin/whisper-cli" "$HOME/.config/waystt/.env"; do
  [[ -f $file ]] || { echo "MISSING dictation dependency: $file"; missing=1; }
done
if command -v qs >/dev/null; then qs --version; fi
printf '%s\n' 'Review monitor names, /home/cobi and /mnt/windows paths in docs/REPLICATION.md.'
exit "$missing"
