#!/usr/bin/env bash
set -euo pipefail
version=3.4.0
checksum=ef552a3e638f25125c6ad4c51176a6adcdce295ab1d2ffacf0db060caf8c1582
cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/fonts"
destination="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMonoNerdFont"
mkdir -p "$cache" "$destination"
archive="$cache/JetBrainsMono-v$version.tar.xz"
if [[ ! -f $archive ]] || ! printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check --status; then
  curl --fail --location --retry 2 --output "$archive" "https://github.com/ryanoasis/nerd-fonts/releases/download/v$version/JetBrainsMono.tar.xz"
fi
printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check
# Fixed upstream release, validated checksum; extract fonts together with licenses.
tar --extract --xz --file "$archive" --directory "$destination" --no-same-owner
fc-cache -f "$destination"
echo 'JetBrainsMono Nerd Font installed.'
