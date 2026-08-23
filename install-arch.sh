#!/usr/bin/env bash
set -e

# ─── Colors ───
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC}  $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ─── Privilege handling ───
if [[ $EUID -eq 0 ]]; then
  info "Running as root. sudo will not be used."
  SUDO=""
else
  if command -v sudo &>/dev/null; then
    SUDO="sudo"
    info "Running as $(id -un). Will use sudo when needed."
  else
    error "sudo is not available and you are not root. Cannot perform privileged operations."
    exit 1
  fi
fi

# ─── Argument parsing ───
INSTALL_CAELESTIA=false
for arg in "$@"; do
  case "$arg" in
  -c | --caelestia)
    INSTALL_CAELESTIA=true
    ;;
  *)
    error "Unknown option: $arg (usage: $0 [-c|--caelestia])"
    exit 1
    ;;
  esac
done

# ─── Sanity check ───
if ! command -v pacman &>/dev/null; then
  error "pacman not found. This script is for Arch-based distros only."
  exit 1
fi

# Configs handed over to Caelestia's out-of-the-box defaults when -c/--caelestia
# is used: they are unstowed and excluded from stowing so Caelestia owns them.
# Everything else (incl. our own caelestia/ and hypr/ tweaks) is always stowed.
CAELESTIA_OOTB=(starship.toml btop)
_stow_ignore="^($(IFS='|'; echo "${CAELESTIA_OOTB[*]//./\\.}"))$"

# ─── Sync package databases ───
info "Syncing package databases..."
$SUDO pacman -Sy --noconfirm

# ─── Pacman packages ───
_arch_pkgs=(
  git
  base-devel
  zsh
  stow
  neovim
  kitty
  btop
  fzf
  python
  python-pip
  python-virtualenv
  python-pipx
  nodejs
  npm
  eza
  gimp
  7zip
  copyq
  ffmpeg
  noto-fonts-cjk
  luarocks
  nmap
  ntfs-3g
  poppler
  sqlite
  gnome-tweaks
  gnome-shell-extensions
  lolcat
  otf-font-awesome
  woff2-font-awesome
  hyprland
  hyprpaper
  hyprlock
  hypridle
  rofi
  waybar
  cups
  cups-filters
  cups-pdf
  system-config-printer
  hyprpolkitagent
  xdg-desktop-portal-hyprland
  fastfetch
  swaync
  libcaca
  cliphist
  wl-clipboard
  alsa-utils
  network-manager-applet
  blueman
  jq
  grim
  slurp
  satty
)

missing=()
for pkg in "${_arch_pkgs[@]}"; do
  if ! pacman -Qi "$pkg" &>/dev/null; then
    missing+=("$pkg")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  info "Installing pacman packages..."
  $SUDO pacman -S --needed --noconfirm "${missing[@]}"
else
  info "All pacman packages already installed."
fi

# ─── Replace mako with swaync ───
if pacman -Qi mako &>/dev/null; then
  info "mako is installed; removing it and replacing with swaync..."
  $SUDO pacman -Rns --noconfirm mako
fi

# ─── yay (AUR helper) ───
if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
  if [[ $EUID -eq 0 ]]; then
    warn "Running as root. Skipping yay installation (makepkg refuses to run as root)."
  else
    info "Installing yay from AUR..."
    _yay_tmp=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$_yay_tmp"
    (
      cd "$_yay_tmp"
      makepkg -si --noconfirm
    )
    rm -rf "$_yay_tmp"
  fi
else
  info "AUR helper (yay/paru) already available."
fi

# Helper to install an AUR package with yay/paru if missing
_aur_install() {
  local pkg=$1 check=${2:-$1}
  if [[ $EUID -eq 0 ]]; then
    warn "Running as root. Skipping $pkg (AUR helpers refuse to run as root)."
  elif command -v yay &>/dev/null; then
    info "Installing $pkg from AUR..."
    yay -S --needed --noconfirm "$pkg"
  elif command -v paru &>/dev/null; then
    info "Installing $pkg from AUR..."
    paru -S --needed --noconfirm "$pkg"
  else
    warn "yay/paru not found. Install $pkg manually from AUR."
  fi
}

# ─── cbonsai (AUR) ───
if ! command -v cbonsai &>/dev/null; then
  _aur_install cbonsai
else
  info "cbonsai already installed."
fi

# ─── Brave (AUR) ───
if ! command -v brave-browser &>/dev/null; then
  _aur_install brave-bin
else
  info "Brave already installed."
fi

# ─── Caelestia Shell + CLI (AUR; pulls in caelestia-cli) ───
if ! pacman -Qi caelestia-shell &>/dev/null; then
  _aur_install caelestia-shell
else
  info "caelestia-shell already installed."
fi

# ─── Ghostty ───
if ! command -v ghostty &>/dev/null; then
  info "Installing Ghostty from pacman..."
  $SUDO pacman -S --needed --noconfirm ghostty
else
  info "Ghostty already installed."
fi

# ─── Homebrew (Linuxbrew) ───
if [[ $EUID -eq 0 ]]; then
  warn "Homebrew refuses to run as root. Skipping Homebrew installation and packages."
else
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew (Linuxbrew)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    info "Homebrew already installed."
  fi

  _brew_pkgs=(zoxide dust duf tldr bat yazi)

  missing=()
  for pkg in "${_brew_pkgs[@]}"; do
    if ! brew list "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    info "Installing Homebrew packages..."
    brew install "${missing[@]}"
  else
    info "All Homebrew packages already installed."
  fi
fi

# ─── Starship ───
if ! command -v starship &>/dev/null; then
  info "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  info "Starship already installed."
fi

# ─── Atuin ───
if ! command -v atuin &>/dev/null; then
  info "Installing Atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  info "Atuin already installed."
fi

# ─── Zinit (Zsh plugin manager) ───
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  info "Installing Zinit..."
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
else
  info "Zinit already installed."
fi

# ─── truesay (npm) ───
if ! command -v truesay &>/dev/null; then
  info "Installing truesay..."
  $SUDO npm install -g truesay
else
  info "truesay already installed."
fi

# ─── OpenCode ───
if ! command -v opencode &>/dev/null; then
  info "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
else
  info "OpenCode already installed."
fi

# ─── Python tools ───
if ! command -v pipx &>/dev/null; then
  warn "pipx not available; skipping Python tools."
else
  _installed_pipx=$(pipx list --short 2>/dev/null)
  for tool in poetry ruff black; do
    if echo "$_installed_pipx" | grep -qx "$tool"; then
      info "$tool already installed via pipx."
    else
      info "Installing $tool via pipx..."
      pipx install "$tool" 2>/dev/null || warn "$tool install failed"
    fi
  done
fi

# ─── Set Zsh as default shell ───
if [[ "$SHELL" != *"zsh"* ]]; then
  info "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
  warn "Log out and back in for the shell change to take effect."
else
  info "Zsh is already the default shell."
fi

# ─── Apply Caelestia Shell GUI (optional; runs last) ───
if [[ "$INSTALL_CAELESTIA" == true ]]; then
  if ! command -v caelestia &>/dev/null; then
    warn "caelestia CLI not found; cannot apply the shell."
    _stow_ignore=""
  else
    # Hand the Caelestia-managed configs over to its defaults: drop our
    # symlinks first so `caelestia install` writes real files (and cannot
    # write through a link into this repo), and exclude them from stowing.
    for name in "${CAELESTIA_OOTB[@]}"; do
      if [[ -L "$HOME/.config/$name" ]]; then
        info "Removing symlink ~/.config/$name (letting Caelestia own it)..."
        rm "$HOME/.config/$name"
      fi
    done
    info "Applying Caelestia Shell..."
    caelestia install --noconfirm || warn "caelestia install failed."
  fi
else
  _stow_ignore=""
  info "Skipping Caelestia Shell setup (pass -c or --caelestia to apply it)."
fi

# ─── Stow dotfiles (last, so our configs override anything installed) ───
info "Stowing dotfiles..."
cd ~/dotfiles
stow -v --adopt --target="$HOME" ${_stow_ignore:+--ignore="$_stow_ignore"} .

echo ""
info "Installation complete! Restart your terminal or run: source ~/.zshrc"

echo ""
info "Installation complete! Restart your terminal or run: source ~/.zshrc"
