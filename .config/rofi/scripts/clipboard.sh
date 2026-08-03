#!/usr/bin/env bash
# Rofi script mode: clipboard history via cliphist, with image previews.
# ROFI_RETV=0 (initial): print cliphist list, flattening multiline entries.
# Image entries get a decoded copy rendered as the row icon.
# ROFI_RETV=1 (selection): copy the selected entry to the clipboard.
set -euo pipefail

CACHE="${XDG_RUNTIME_DIR:-/tmp}/rofi-cliphist"
FMT_RE='(png|jpe?g|webp|gif|bmp|tiff|avif|heic|svg)'

case "${ROFI_RETV:-0}" in
    0)
        mkdir -p "$CACHE"
        cliphist list | awk 'BEGIN{FS="\t"} /^[0-9]+\t/ { if (id!="") print line; id=$1; line=$0; next } { line = line " " $0 } END { if (id!="") print line }' |
        while IFS= read -r line; do
            id="${line%%$'\t'*}"
            rest="${line#*$'\t'}"
            if [[ "$rest" =~ ^\[\[[[:space:]]binary[[:space:]]data ]] && [[ "$rest" =~ $FMT_RE ]]; then
                ext="${BASH_REMATCH[1]}"
                file="$CACHE/$id.$ext"
                [[ -f "$file" ]] || printf '%s\t\n' "$id" | cliphist decode > "$file"
                printf '%s\t%s\0icon\x1f%s\n' "$id" "$rest" "$file"
            else
                printf '%s\n' "$line"
            fi
        done
        ;;
    *)
        selection="${1:-}"
        id="${selection%%$'\t'*}"
        if [[ "$id" =~ ^[0-9]+$ ]]; then
            printf '%s\t\n' "$id" | cliphist decode | wl-copy
        fi
        ;;
esac
