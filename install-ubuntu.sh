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

# ─── Sanity check ───
if ! command -v apt &>/dev/null; then
  error "apt not found. This script is for Ubuntu/Debian-based distros only."
  exit 1
fi

if [[ $# -gt 0 ]]; then
  error "This script takes no options (Caelestia Shell is Arch-only: use install-arch.sh -c there)."
  exit 1
fi

# ─── APT packages ───
info "Updating package lists..."
$SUDO apt update

_apt_pkgs=(
  curl
  ca-certificates
  git
  zsh
  stow
  neovim
  kitty
  btop
  fzf
  lolcat
  cbonsai
  python3
  python3-pip
  python3-venv
  nodejs
  npm
  eza
  gimp
  7zip
  copyq
  ffmpeg
  fonts-noto-cjk
  luarocks
  nmap
  ntfs-3g
  poppler-utils
  sqlite3
  gnome-tweaks
  gnome-shell-extension-manager
)

missing=()
for pkg in "${_apt_pkgs[@]}"; do
  if ! dpkg -s "$pkg" &>/dev/null; then
    missing+=("$pkg")
  fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
  info "Installing APT packages..."
  $SUDO apt install -y "${missing[@]}"
else
  info "All APT packages already installed."
fi

# ─── Brave ───
if ! command -v brave-browser &>/dev/null; then
  info "Installing Brave..."
  $SUDO curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" |
    $SUDO tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
  $SUDO apt update
  $SUDO apt install -y brave-browser
else
  info "Brave already installed."
fi

# ─── Ghostty ───
if ! command -v ghostty &>/dev/null; then
  info "Installing Ghostty..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
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
  info "Installing pipx..."
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
else
  info "pipx already installed."
fi

_installed_pipx=$(pipx list --short 2>/dev/null)
for tool in poetry ruff black; do
  if echo "$_installed_pipx" | grep -qx "$tool"; then
    info "$tool already installed via pipx."
  else
    info "Installing $tool via pipx..."
    pipx install "$tool" 2>/dev/null || warn "$tool install failed"
  fi
done

# ─── Stow dotfiles ───
info "Stowing dotfiles..."
cd ~/dotfiles
stow -v --adopt --target="$HOME" .

# ─── Set Zsh as default shell ───
if [[ "$SHELL" != *"zsh"* ]]; then
  info "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
  warn "Log out and back in for the shell change to take effect."
else
  info "Zsh is already the default shell."
fi

echo ""
info "Installation complete! Restart your terminal or run: source ~/.zshrc"
