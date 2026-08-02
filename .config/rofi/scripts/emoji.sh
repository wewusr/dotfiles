#!/usr/bin/env bash
# Rofi script mode: emoji picker.
# ROFI_RETV=0 (initial): print the emoji list.
# ROFI_RETV=1 (selection): copy the emoji to the clipboard; printing
# nothing makes rofi quit.
set -euo pipefail
EMOJI_LIST="$(dirname "$0")/emoji_list.txt"

case "${ROFI_RETV:-0}" in
    0)
        cat "$EMOJI_LIST"
        ;;
    *)
        selection="${1:-}"
        emoji="${selection%%$'\t'*}"
        if [ -n "$emoji" ]; then
            printf '%s' "$emoji" | wl-copy
        fi
        ;;
esac
