#!/usr/bin/env bash
set -euo pipefail

DOTS="${HOME}/dotfiles"
CONFIG="${HOME}/.config"

echo "== Caelestia live-USB config linker (fix #1) =="
echo "Makes ~/dotfiles the source of truth for the Hyprland + shell configs."

if [ ! -d "${DOTS}/.config/hypr" ] || [ ! -d "${DOTS}/.config/caelestia" ]; then
    echo "ERROR: expected ${DOTS}/.config/hypr and ${DOTS}/.config/caelestia."
    echo "Clone the dotfiles repo at exactly ${DOTS} first, then re-run."
    exit 1
fi

if command -v hyprctl >/dev/null 2>&1; then
    echo "Hyprland: $(hyprctl version 2>/dev/null | head -1)"
else
    echo "WARNING: hyprctl not found - install caelestia-shell, caelestia-cli and quickshell-git (and Hyprland >= 0.56 for the lua config provider) first."
fi

for name in hypr caelestia; do
    link="${CONFIG}/${name}"
    target="${DOTS}/.config/${name}"

    if [ -L "${link}" ]; then
        echo "OK: ${link} is already a symlink -> $(readlink "${link}")"
        continue
    fi

    if [ -e "${link}" ]; then
        backup="${CONFIG}/${name}.bak.$(date +%Y%m%d-%H%M%S)"
        echo "Backing up existing ${link} to ${backup}"
        mv "${link}" "${backup}"
    fi

    ln -s "${target}" "${link}"
    echo "Linked ${link} -> ${target}"
done

if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    echo "Reloading Hyprland..."
    hyprctl reload >/dev/null
    hyprctl systeminfo | grep -i "config" || true
    binds="$(hyprctl binds 2>/dev/null | grep -c 'key:')"
    echo "Active binds: ${binds}"
    if [ "${binds:-0}" -eq 0 ]; then
        echo "WARNING: no binds active - check the Hyprland log for lua errors:"
        echo "  $XDG_RUNTIME_DIR/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/hyprland.log"
    fi
else
    echo "Hyprland is not running in this shell (expected before login). Re-login to apply."
fi

echo
echo "Done. Now edit files under ${DOTS}/.config/ and they become the live config."
echo "Notes:"
echo "  - hyprctl reload re-applies Hyprland config; Ctrl+Super+Alt+R restarts the shell."
echo "  - shell configs do NOT auto-reload (watchFiles=false); restart the shell after editing shell.json/cli.json."
echo "  - theme/monitor changes write into the dotfiles repo (scheme/current.lua, monitors/) - commit them if desired."
