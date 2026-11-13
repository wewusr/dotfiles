# Dotfiles

Personal dotfiles for an **Arch-based Hyprland** desktop (with a lighter **Ubuntu/Debian** fallback), managed with [GNU Stow](https://www.gnu.org/software/stow/) as a single top-level stow package — every path in this repo maps 1:1 to `$HOME`.

## What's included

| Tool | Config | Purpose |
|------|--------|---------|
| zsh | `.zshrc` | Shell with Zinit plugins, Starship prompt, Atuin history, zoxide navigation |
| Neovim | `.config/nvim` | LazyVim-based editor configuration |
| Kitty | `.config/kitty` | Terminal emulator |
| Ghostty | `.config/ghostty` | Terminal emulator |
| Atuin | `.config/atuin` | Shell history sync and search |
| Starship | `.config/starship.toml` | Shell prompt theme |
| btop | `.config/btop` | System monitor |
| bat | `.config/bat` | File previewer theme |
| OpenCode | `.config/opencode` | AI coding assistant config |
| Hyprland | `.config/hypr` | Window manager stack: hyprland (Lua-driven config), hyprlock, hyprpaper, hypridle |
| Caelestia | `.config/caelestia` | Quickshell desktop shell config (shell.json, CLI theming, Hyprland overrides) — see [caelestia-shortcuts.md](caelestia-shortcuts.md) |
| Waybar | `.config/waybar` | Status bar for the non-Caelestia setup |
| SwayNC | `.config/swaync` | Notification daemon |
| Rofi | `.config/rofi` | Launchers (power menu, wifi, emoji, clipboard, screenshots, …) and themes |
| fish | `.config/fish` | Interactive shell configuration |
| foot | `.config/foot` | Terminal emulator |
| fastfetch | `.config/fastfetch` | System information dashboard |
| micro | `.config/micro` | Terminal-based text editor |
| uwsm | `.config/uwsm` | Wayland session management |
| GTK | `.config/gtk-3.0`, `.config/gtk-4.0`, `.gtkrc`, `.gtkrc-2.0` | GTK theming |
| VSCodium | `.config/VSCodium` | Editor settings (User directory synced; cache excluded) |
| Fonts | `.fonts` | FiraCode Nerd Font + Arabic calligraphy fonts |
| Icons | `.local/share/icons` | Tela icon themes |

## Installation

```bash
git clone --depth=1 https://github.com/wewusr/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Arch-based (Arch, EndeavourOS, Manjaro, Garuda, Artix)
chmod +x install-arch.sh
./install-arch.sh            # add -c / --caelestia to also install Caelestia Shell (slow build)

# Ubuntu/Debian-based (Ubuntu, Debian, Pop!_OS, Linux Mint, elementary)
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

Each distro has its own standalone script — pick the one matching your system.

### `install-arch.sh`

1. **Pacman packages** — git, base-devel, zsh, stow, neovim, kitty, the Hyprland stack (hyprland, hyprlock, hyprpaper, hypridle, xdg-desktop-portal-hyprland, hyprpolkitagent), Waybar, Rofi, SwayNC, printing (CUPS), Bluetooth, fonts, and more
2. **yay bootstrap** — builds yay from the AUR when neither yay nor paru is present
3. **AUR packages** — cbonsai, Brave (`brave-bin`), Caelestia Shell (`caelestia-shell`, pulls in `caelestia-cli`)
4. **Ghostty** — from the official repos
5. **Apply Caelestia Shell** *(optional)* — only with `-c` / `--caelestia`; removes the repo's symlinks for `starship.toml` and `btop`, then runs `caelestia install --noconfirm` so those come straight from Caelestia's out-of-the-box defaults (stow skips them afterwards). Your `caelestia/` and `hypr/` tweaks are always kept. Run without the flag to have your own dots win everywhere instead.

### `install-ubuntu.sh`

1. **APT packages** — same core tools (zsh, stow, neovim, kitty, btop, fzf, Python 3, Node.js, …)
2. **Brave** — via the official Brave apt repository
3. **Ghostty** — via the [ghostty-ubuntu](https://github.com/mkasberg/ghostty-ubuntu) community build

### Common to both scripts

1. **Homebrew** — Linuxbrew plus zoxide, dust, duf, tldr, bat, yazi
2. **Shell tools** — Starship prompt, Atuin, Zinit plugin manager, truesay
3. **OpenCode** — AI coding assistant
4. **Python tools** — pipx with poetry, ruff, black
5. **Default shell** — sets Zsh as the default
6. **Stow** — symlinks all dotfiles into `$HOME` (always last, so the repo's configs override anything installed above; on Arch the Caelestia-managed paths are excluded when `-c` was passed)

> Both scripts are **idempotent**: they check before every step and skip anything already installed, so they're safe to re-run.
>
> Do **not** run the scripts as root. They will prompt for `sudo` when needed. (AUR/Homebrew steps refuse root and are skipped.)

## Manual stow usage

```bash
# Re-stow dotfiles without the full install
cd ~/dotfiles
stow -v --target="$HOME" .

# Unstow (remove symlinks)
stow -Dv --target="$HOME" .
```

## Adding new configs

Place config files in the expected paths under this repo (e.g. `~/.config/btop/btop.conf` should live at `.config/btop/btop.conf` in the repo). Running `stow` will symlink them to `$HOME`.
