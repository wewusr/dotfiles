#!/usr/bin/env bash
# Microphone control menu via rofi (script mode).
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        printf 'Mute / Unmute\nVolume -10%%\nVolume +10%%\nAudio settings\n'
        ;;
    *)
        case "${1:-}" in
            'Mute / Unmute') pactl set-source-mute @DEFAULT_SOURCE@ toggle ;;
            'Volume -10%') pactl set-source-volume @DEFAULT_SOURCE@ -10% ;;
            'Volume +10%') pactl set-source-volume @DEFAULT_SOURCE@ +10% ;;
            'Audio settings') pavucontrol ;;
        esac
        ;;
esac
