#!/usr/bin/env bash
# Rofi script mode: clipboard history via cliphist.
# ROFI_RETV=0 (initial): print cliphist list, flattening multiline entries.
# ROFI_RETV=1 (selection): copy the selected entry to the clipboard.
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        cliphist list | awk 'BEGIN{FS="\t"} /^[0-9]+\t/ { if (id!="") print line; id=$1; line=$0; next } { line = line " " $0 } END { if (id!="") print line }'
        ;;
    *)
        selection="${1:-}"
        id="${selection%%$'\t'*}"
        if [[ "$id" =~ ^[0-9]+$ ]]; then
            printf '%s\t\n' "$id" | cliphist decode | wl-copy
        fi
        ;;
esac
