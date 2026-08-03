#!/usr/bin/env bash
# Volume control menu via rofi (script mode).
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        printf 'Mute / Unmute\nVolume -10%%\nVolume +10%%\nAudio settings\n'
        ;;
    *)
        case "${1:-}" in
            'Mute / Unmute') wpctl set-mute @DEFAULT_SINK@ toggle ;;
            'Volume -10%') wpctl set-volume @DEFAULT_SINK@ 10%- ;;
            'Volume +10%') wpctl set-volume @DEFAULT_SINK@ 10%+ ;;
            'Audio settings') pavucontrol ;;
        esac
        ;;
esac
