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

# ─── Distro detection ───
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
      arch|endeavouros|manjaro|garuda|artix)
        echo "arch"
        return
        ;;
      ubuntu|debian|pop|linuxmint|elementary)
        echo "debian"
        return
        ;;
    esac
  fi
  # Fallback: check package manager
  if command -v pacman &>/dev/null; then
    echo "arch"
  elif command -v apt &>/dev/null; then
    echo "debian"
  else
    echo "unknown"
  fi
}

DISTRO=$(detect_distro)
info "Detected distro type: $DISTRO"

# ─── Package installation ───
if [[ "$DISTRO" == "debian" ]]; then
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

  # ─── Brave (Debian) ───
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

  # ─── Ghostty (Debian) ───
  if ! command -v ghostty &>/dev/null; then
    info "Installing Ghostty..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
  else
    info "Ghostty already installed."
  fi

elif [[ "$DISTRO" == "arch" ]]; then
  info "Installing packages with pacman..."

  # Helper to install a list of packages if missing
  _arch_pkgs=(
    zsh
    stow
    neovim
    kitty
    btop
    fzf
    python
    nodejs
    npm
    eza
    gimp
    p7zip
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
  )

  for pkg in "${_arch_pkgs[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    sudo pacman -S --noconfirm "${missing[@]}"
  else
    info "All pacman packages already installed."
  fi

  # ─── cbonsai (AUR) ───
  if ! command -v cbonsai &>/dev/null; then
    if command -v yay &>/dev/null; then
      info "Installing cbonsai from AUR..."
      yay -S --noconfirm cbonsai
    elif command -v paru &>/dev/null; then
      info "Installing cbonsai from AUR..."
      paru -S --noconfirm cbonsai
    else
      warn "yay/paru not found. Install cbonsai manually from AUR."
    fi
  else
    info "cbonsai already installed."
  fi

  # ─── Brave (Arch) ───
  if ! command -v brave-browser &>/dev/null; then
    if command -v yay &>/dev/null; then
      info "Installing Brave from AUR..."
      yay -S --noconfirm brave-bin
    elif command -v paru &>/dev/null; then
      info "Installing Brave from AUR..."
      paru -S --noconfirm brave-bin
    else
      warn "yay/paru not found. Install brave-bin manually from AUR."
    fi
  else
    info "Brave already installed."
  fi

  # ─── Ghostty (Arch) ───
  if ! command -v ghostty &>/dev/null; then
    info "Installing Ghostty from pacman..."
    sudo pacman -S --noconfirm ghostty
  else
    info "Ghostty already installed."
  fi

else
  warn "Unknown distro. Skipping package manager steps."
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
