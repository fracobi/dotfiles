jq -r '.[] | select((.quoteText | length) < 160 and .quoteText != "") | "\"\(.quoteText)\" — \(.quoteAuthor // "Unknown")"' /home/cobi/.config/hypr/data/quotes.json | shuf -n 1
