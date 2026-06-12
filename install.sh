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

# ─── Check for root ───
if [[ $EUID -eq 0 ]]; then
  error "Do not run this script as root. It will ask for sudo when needed."
  exit 1
fi

# ─── APT packages ───
info "Updating package lists..."
sudo apt update

info "Installing APT packages..."
sudo apt install \
  zsh \
  stow \
  neovim \
  kitty \
  btop \
  fzf \
  lolcat \
  cbonsai \
  python3 \
  nodejs \
  npm \
  eza \
  gimp \
  7zip \
  copyq \
  ffmpeg \
  fonts-noto-cjk \
  jp \
  luarocks \
  nmap \
  ntfs-3g \
  poppler-utils \
  sqlite3 \
  gnome-tweaks \
  gnome-shell-extension-manager

# ─── Brave ───
if ! command -v brave-browser &>/dev/null; then
  info "Installing Brave..."
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
    https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" |
    sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
  sudo apt update
  sudo apt install -y brave-browser
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
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew (Linuxbrew)..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  info "Homebrew already installed."
fi

# ─── Brew packages ───
info "Installing Homebrew packages..."
brew install zoxide dust duf tldr bat yazi

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
  sudo npm install -g truesay
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
