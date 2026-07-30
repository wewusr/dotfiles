# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| Tool | Config | Purpose |
|------|--------|---------|
| zsh | `.zshrc` | Shell with Zinit plugins, Starship prompt, Atuin history, zoxide navigation |
| Neovim | `.config/nvim` | Editor configuration |
| Starship | `.config/starship.toml` | Shell prompt theme |
| Kitty | `.config/kitty` | Terminal emulator |
| Ghostty | `.config/ghostty` | Terminal emulator |
| Atuin | `.config/atuin` | Shell history sync and search |
| btop | `.config/btop` | System monitor |
| bat | `.config/bat` | File previewer theme |
| OpenCode | `.config/opencode` | AI coding assistant config |

## Installation

```bash
git clone --depth=1 https://github.com/wewusr/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:

1. **System packages** — Installs packages via APT (Debian) or pacman (Arch) including zsh, stow, neovim, kitty, btop, fzf, Python 3, Node.js, and more
2. **Python setup** — Installs pip, venv, pipx, and Python tools (poetry, ruff, black)
3. **Homebrew** — Installs Linuxbrew and packages (zoxide, dust, duf, tldr, bat, yazi)
4. **Shell tools** — Starship prompt, Atuin, Zinit plugin manager, truesay
5. **OpenCode** — AI coding assistant
6. **Stow** — Symlinks all dotfiles to `$HOME`
7. **Default shell** — Sets Zsh as the default shell

> Do **not** run the script as root. It will prompt for `sudo` when needed.

## Supported distros

- **Debian-based**: Ubuntu, Debian, Pop!_OS, Linux Mint, elementary
- **Arch-based**: Arch, EndeavourOS, Manjaro, Garuda, Artix

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
=======
