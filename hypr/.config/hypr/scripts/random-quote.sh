#!/usr/bin/env bash

set -euo pipefail

jq -r '.[] | select((.quoteText | length) < 160 and .quoteText != "") | "\"\(.quoteText)\" — \(.quoteAuthor // "Unknown")"' \
  "${HOME}/.config/hypr/data/quotes.json" | shuf -n 1
