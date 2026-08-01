#!/usr/bin/env bash
# Waybar keyboard layout indicator for Hyprland.
# Prints the active layout and updates on activelayout events.
exec 2>/dev/null

sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

label() {
  case "$1" in
    *English*) echo "EN" ;;
    *Russian*) echo "RU" ;;
    *Arabic*) echo "AR" ;;
    *) echo "$1" ;;
  esac
}

current() {
  hyprctl devices -j 2>/dev/null | jq -r '.keyboards[] | select(.name != "dummy") | .active_keymap' | head -1
}

label "$(current)"

if [[ -S "$sock" ]]; then
  socat -u "UNIX-CONNECT:$sock" - 2>/dev/null | stdbuf -o0 awk -F '>>|,' '/activelayout/ {print $3}' | while read -r l; do
    label "$l"
  done
fi
