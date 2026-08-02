#!/usr/bin/env bash
# Workaround for hyprwm/Hyprland#7044 / #8150: switchxkblayout fired from a
# keybind desyncs the xkb group after a few presses. A tiny delay lets the key
# event finish processing before the keymap is swapped.
sleep 0.1
hyprctl switchxkblayout all next
