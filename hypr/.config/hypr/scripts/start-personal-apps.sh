#!/usr/bin/env bash
set -euo pipefail
app=brave-hnpfjngllnobngcgfapefoaidbinmjnm-Default
[[ -f ${XDG_DATA_HOME:-$HOME/.local/share}/applications/$app.desktop ]] || exit 0
sleep 10
exec gtk-launch "$app"
