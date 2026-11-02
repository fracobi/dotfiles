#!/usr/bin/env bash
set -uo pipefail
strict=0
case ${1:-} in '' ) ;; --strict) strict=1 ;; *) echo 'Usage: check-setup.sh [--strict]' >&2; exit 2 ;; esac
required=0
optional=0
for cmd in hyprland hyprctl qs uwsm kitty zsh starship atuin zoxide fzf eza bat jq grim slurp hyprshot wl-copy wl-paste dbus-monitor dbus-update-activation-environment cliphist brightnessctl playerctl wpctl hyprlock hypridle brave-browser matugen magick fc-match; do
  command -v "$cmd" >/dev/null || { echo "BASE MANCANTE: $cmd — riesegui ./bootstrap-fedora.sh"; required=$((required+1)); }
done
[[ -x /usr/libexec/hyprpolkitagent ]] || command -v hyprpolkitagent >/dev/null || { echo 'BASE MANCANTE: hyprpolkitagent'; required=$((required+1)); }
if command -v qs >/dev/null; then
  version=$(qs --version 2>&1)
  echo "$version"
  [[ $version == *noctalia-qs* ]] || { echo 'BASE MANCANTE: runtime noctalia-qs compatibile'; required=$((required+1)); }
fi
if command -v fc-match >/dev/null && ! fc-match -f '%{family}' 'JetBrainsMono Nerd Font' | grep -q 'JetBrainsMono Nerd Font'; then
  echo 'BASE MANCANTE: font — esegui ./scripts/install-fonts.sh'
  required=$((required+1))
fi
for spec in 'spf:Superfile (Super+Y)' 'wvkbd-mobintl:tastiera virtuale (Super+K)' 'llm-chat:assistente locale Kitty (Ctrl+Shift+E)' 'nmtui-go:pannello rete personalizzato'; do
  cmd=${spec%%:*}
  command -v "$cmd" >/dev/null || { echo "OPZIONALE: ${spec#*:} — vedi docs/MIGRATION.md"; optional=$((optional+1)); }
done
for file in "$HOME/.local/share/whisper.cpp/build/bin/whisper-cli" "$HOME/.config/waystt/.env"; do
  [[ -f $file ]] || { echo "OPZIONALE dettatura: manca $file — vedi docs/MIGRATION.md"; optional=$((optional+1)); }
done
# Read a model name as data; never source a .env as shell code.
if [[ -f $HOME/.config/waystt/.env ]]; then
  model=$(sed -n 's/^WHISPER_MODEL=//p' "$HOME/.config/waystt/.env" | head -1)
  [[ -f $HOME/.local/share/applications/waystt/models/${model:-ggml-base.bin} ]] || { echo 'OPZIONALE dettatura: manca il modello Whisper'; optional=$((optional+1)); }
fi
if [[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
  for unit in graphical-session.target xdg-desktop-portal.service xdg-desktop-portal-hyprland.service; do
    systemctl --user is-active --quiet "$unit" || { echo "SESSIONE: $unit inattivo — accedi con Hyprland (uwsm-managed)"; required=$((required+1)); }
  done
else
  echo 'SESSIONE: verifica i portali da un terminale Hyprland dopo il login UWSM.'
fi
printf '\nBase: %s problemi. Componenti opzionali da completare: %s.\n' "$required" "$optional"
echo 'Checklist dati, account, monitor e plugin: docs/MIGRATION.md'
(( required == 0 && (strict == 0 || optional == 0) ))
