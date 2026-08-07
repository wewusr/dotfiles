# Caelestia Shell — Default Shortcuts

Caelestia Shell on Hyprland (from `~/.config/hypr/hyprland/keybinds.lua` and `variables.lua`).

## Shell / system

| Action | Keys |
|---|---|
| Launcher (search) | `SUPER` + `SUPER_L` (tap Super) |
| Session / logout menu | `CTRL` + `ALT` + `Delete` |
| Sidebar | `SUPER` + `N` |
| Show all panels | `SUPER` + `K` |
| Lock screen | `SUPER` + `L` |
| Restore + lock | `SUPER` + `ALT` + `L` |
| Sleep | `SUPER` + `SHIFT` + `L` |
| Clear notifications | `CTRL` + `ALT` + `C` |
| Kill shell | `CTRL` + `SUPER` + `SHIFT` + `R` |
| Restart shell | `CTRL` + `SUPER` + `ALT` + `R` |

## Windows

| Action | Keys |
|---|---|
| Close | `SUPER` + `Q` |
| Fullscreen | `SUPER` + `F` |
| Fullscreen (bordered) | `SUPER` + `ALT` + `F` |
| Toggle float | `SUPER` + `ALT` + `Space` |
| Focus window | `SUPER` + arrows |
| Move window | `SUPER` + `SHIFT` + arrows |
| Resize | `SUPER` + `-` / `=` (`+SHIFT` = height; or `SUPER` + `ALT` + arrows) |
| Cycle window | `ALT` + `Tab` / `SHIFT` + `ALT` + `Tab` |
| Cycle window group | `CTRL` + `ALT` + `Tab` / `CTRL` + `SHIFT` + `ALT` + `Tab` |
| Group | `SUPER` + `,` |
| Ungroup | `SUPER` + `U` |
| Toggle group lock | `SUPER` + `SHIFT` + `,` |
| Pin | `SUPER` + `P` |
| PiP | `SUPER` + `ALT` + `\` |
| Center | `CTRL` + `SUPER` + `\` |
| Normalize | `CTRL` + `SUPER` + `ALT` + `\` |
| Drag with mouse | hold `SUPER` + `Z` |
| Resize with mouse | hold `SUPER` + `X` |

## Workspaces

| Action | Keys |
|---|---|
| Go to workspace 1–10 | `SUPER` + number |
| Move window to workspace 1–10 | `SUPER` + `SHIFT` + number |
| Go to workspace group 1–10 | `CTRL` + `SUPER` + number |
| Move window to workspace group 1–10 | `CTRL` + `SUPER` + `ALT` + number |
| Next / prev workspace | `SUPER` + scroll, `SUPER` + `Page_Down/Up`, `CTRL` + `SUPER` + `Right/Left` |
| Move window next / prev workspace | `SUPER` + `ALT` + scroll, `SUPER` + `ALT` + `Page_Down/Up`, `CTRL` + `SUPER` + `SHIFT` + `Right/Left` |
| Special workspace (scratchpad) | `SUPER` + `S` |
| Move window to/from special | `SUPER` + `ALT` + `S` / `CTRL` + `SUPER` + `SHIFT` + `Up/Down` |
| Music workspace | `SUPER` + `M` |
| Communication workspace | `SUPER` + `D` |
| Todo workspace | `SUPER` + `R` |
| System monitor workspace | `CTRL` + `SHIFT` + `Escape` |

## Apps & tools

| Action | Keys |
|---|---|
| Terminal (kitty) | `SUPER` + `T` |
| Browser (brave) | `SUPER` + `W` |
| Editor (nvim) | `SUPER` + `C` |
| File manager (nautilus) | `SUPER` + `E` |
| Audio settings | `CTRL` + `ALT` + `V` |
| Screenshot | `Print` |
| Screenshot region | `SUPER` + `SHIFT` + `ALT` + `S` |
| Screenshot freeze | `SUPER` + `SHIFT` + `S` |
| Record screen | `CTRL` + `ALT` + `R` |
| Record sound | `SUPER` + `ALT` + `R` |
| Record region | `SUPER` + `SHIFT` + `ALT` + `R` |
| Color picker | `SUPER` + `SHIFT` + `C` |
| Clipboard | `SUPER` + `V` |
| Clipboard delete | `SUPER` + `ALT` + `V` |
| Paste latest clipboard | `CTRL` + `SHIFT` + `ALT` + `V` |
| Emoji picker | `SUPER` + `.` |

## Media / volume

| Action | Keys |
|---|---|
| Media toggle | `CTRL` + `SUPER` + `Space` |
| Media next / prev / stop | `CTRL` + `SUPER` + `=` / `-` / `Backspace` |
| Volume mute | `SUPER` + `SHIFT` + `M` |
| Volume up / down | `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` |
| Mic mute | `XF86AudioMicMute` |
| Brightness up / down | `XF86MonBrightnessUp` / `XF86MonBrightnessDown` |

## Input

| Action | Keys |
|---|---|
| Toggle keyboard layout (us/ara) | `SUPER` + `Space` — works even when locked |

Defined in `~/.config/caelestia/hypr-user.lua` (`hl.bind("SUPER + Space", ...)`). Uses `{ locked = true }` so you can switch to English to type your password if the lock screen is stuck on Arabic. If you change the key, use the keysym spelling shown in `hyprctl binds -j` (e.g. `Space`, not `SPACE`).

## Customizing

Overrides go in `~/.config/caelestia/hypr-vars.lua` (e.g. `kbTerminal = "SUPER + Return"`). They survive `caelestia update`. Keybind variable names are the `kb*` entries in `~/.config/hypr/variables.lua`.

Note: `CTRL` + `SUPER` + `Left/Right` are taken by workspace switching, so window resizing on `CTRL` + `SUPER` + arrows is not available without rebinding those first.
