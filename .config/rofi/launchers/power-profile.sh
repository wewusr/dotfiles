#!/usr/bin/env bash
# Power consumption mode selector via rofi (script mode).
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        printf 'Performance\nBalanced\nPower Saver\n'
        ;;
    *)
        case "${1:-}" in
            Performance) powerprofilesctl set performance ;;
            Balanced) powerprofilesctl set balanced ;;
            'Power Saver') powerprofilesctl set power-saver ;;
        esac
        ;;
esac
