#!/usr/bin/env bash
# Screenshot mode selector via rofi.
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        printf 'Region\nActive window\nFull screen\n'
        ;;
    *)
        case "${1:-}" in
            Region) hyprshot -m region -o "$HOME/Pictures/Screenshots" ;;
            Active\ window) hyprshot -m window -o "$HOME/Pictures/Screenshots" ;;
            Full\ screen) hyprshot -m output -o "$HOME/Pictures/Screenshots" ;;
        esac
        ;;
esac
