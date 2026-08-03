#!/usr/bin/env bash
# Wifi network selector via rofi.
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        nmcli -t -f active,ssid,signal device wifi list | awk -F: '
            { sig=$3+0; icon=" "; if ($1=="yes") icon="[ON]"; if ($2!="") printf "%s %s (%d%%)\n", icon, $2, sig }'
        ;;
    *)
        ssid="$(printf '%s' "${1:-}" | sed -e 's/^\[ON\] //' -e 's/ ([0-9]*%)$//' -e 's/^ //')"
        if [[ -n "$ssid" ]]; then
            nmcli device wifi connect "$ssid" >/dev/null 2>&1 &&
                notify-send "WiFi" "Connected to $ssid" ||
                notify-send -u critical "WiFi" "Failed to connect to $ssid"
        fi
        ;;
esac
