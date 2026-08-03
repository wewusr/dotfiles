#!/usr/bin/env bash
# Wallpaper picker for hyprpaper via rofi.
set -euo pipefail

WALL_DIR="${WALL_DIR:-$HOME/Pictures/Wallpapers}"
[ -d "$WALL_DIR" ] || WALL_DIR="$HOME/.config/hypr"

case "${ROFI_RETV:-0}" in
    0)
        find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.bmp' \) -printf '%f\n' | sort
        ;;
    *)
        path="$WALL_DIR/${1:-}"
        if [[ -f "$path" ]]; then
            hyprctl hyprpaper preload "$path" >/dev/null 2>&1
            hyprctl hyprpaper wallpaper ",$path" >/dev/null 2>&1
            sed -i "s|^wallpaper.*|wallpaper {\n    monitor =\n    path = $path\n    fit_mode = cover\n}|" "$HOME/.config/hypr/hyprpaper.conf"
        fi
        ;;
esac
