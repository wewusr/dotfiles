#!/usr/bin/env bash
# Power menu via rofi.
set -euo pipefail

case "${ROFI_RETV:-0}" in
    0)
        printf 'Lock\nSwitch User\nLogout\nSuspend\nHibernate\nReboot\nShutdown\n'
        ;;
    *)
        case "${1:-}" in
            Lock) hyprlock ;;
            'Switch User') qdbus6 --system org.freedesktop.DisplayManager /org/freedesktop/DisplayManager/Seat0 org.freedesktop.DisplayManager.Seat.SwitchToGreeter ;;
            Logout) hyprctl dispatch 'hl.dsp.exit()' ;;
            Suspend) systemctl suspend ;;
            Hibernate) systemctl hibernate ;;
            Reboot) systemctl reboot ;;
            Shutdown) systemctl poweroff ;;
        esac
        ;;
esac
