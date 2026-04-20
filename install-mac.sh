#!/bin/bash

set -euo pipefail

# install-mac.sh — Bootstrap dotfiles on macOS
# Clones the repo (if needed), installs dependencies via Homebrew,
# installs Oh My Zsh, and symlinks all dotfiles into place.

DOTFILES_REPO="https://github.com/matthewljiang/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# ── Helpers ──────────────────────────────────────────────────────────────────

info()  { echo "[info]  $*"; }
warn()  { echo "[warn]  $*"; }
error() { echo "[error] $*" >&2; exit 1; }

# Creates a symlink, backing up any pre-existing file/directory first.
link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ]; then
      info "already linked: $dst"
      return
    fi
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    warn "backing up existing $dst → $backup"
    mv "$dst" "$backup"
  fi
  ln -s "$src" "$dst"
  info "linked: $dst → $src"
}

# ── Homebrew ─────────────────────────────────────────────────────────────────

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH for the rest of this script (Apple Silicon default path)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Dependencies ─────────────────────────────────────────────────────────────

info "Installing packages..."
brew install neovim node python3 ripgrep fd stylua gh
brew install --cask alacritty


mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

fpath+=($HOME/.zsh/pure)

# ── Repo ─────────────────────────────────────────────────────────────────────

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  info "Cloning dotfiles into $DOTFILES_DIR..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  info "Dotfiles repo already present at $DOTFILES_DIR, pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

# ── Oh My Zsh ────────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  # RUNZSH=no prevents the installer from launching a new shell and blocking the script
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  info "Oh My Zsh already installed"
fi

# ── Symlinks ─────────────────────────────────────────────────────────────────

info "Linking dotfiles..."

link "$DOTFILES_DIR/.zshrc"  "$HOME/.zshrc"
link "$DOTFILES_DIR/.vimrc"  "$HOME/.vimrc"

mkdir -p "$HOME/.config"
link "$DOTFILES_DIR/.config/nvim"       "$HOME/.config/nvim"
mkdir -p "$HOME/.config/alacritty"
link "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# ── Done ─────────────────────────────────────────────────────────────────────

source ~/.zshrc
info "Done. Start a new shell or run: source ~/.zshrc"
