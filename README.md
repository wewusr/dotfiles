# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

- **zsh** — Shell configuration (`.zshrc`)
- **Neovim** — Editor config
- **Starship** — Shell prompt theme
- **Kitty** — Terminal emulator config
- **Atuin** — Shell history sync
- **btop** — System monitor config

## Installation

Clone the repo and run the install script:

```bash
git clone --depth=1 https://github.com/wewusr/dotfiles.git
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The script will:

1. Install APT packages (zsh, stow, neovim, kitty, btop, fzf, etc.)
2. Install Homebrew and brew packages (eza, zoxide, dust, duf, tldr)
3. Install Starship prompt, Atuin, and Zinit
4. Symlink all dotfiles to `$HOME` using `stow`
5. Set Zsh as the default shell

> Do **not** run the script as root. It will prompt for `sudo` when needed.

## Manual stow usage

To re-stow the dotfiles without running the full install:

```bash
cd ~/dotfiles
stow -v --target="$HOME" .
```

To unstow (remove symlinks):

```bash
cd ~/dotfiles
stow -Dv --target="$HOME" .
```
