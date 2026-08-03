#!/usr/bin/env bash
# Toggle bluetooth power, starting the daemon if needed.
set -euo pipefail

if ! systemctl is-active --quiet bluetooth; then
    systemctl start bluetooth
    sleep 1
    timeout 5 bluetoothctl power on
else
    timeout 5 bluetoothctl power toggle
fi
