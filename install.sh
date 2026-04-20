#!/bin/bash

set -euo pipefail

# install.sh — Bootstrap dotfiles on Linux (Ubuntu/Debian / GitHub Codespaces)
# Clones the repo (if needed), installs dependencies via apt-get,
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

# ── Dependencies ─────────────────────────────────────────────────────────────

info "Installing packages..."
sudo apt-get update -y
sudo apt-get install -y neovim nodejs npm python3 python3-pip ripgrep fd-find


# stylua is not in apt; install via cargo if available, else download from GitHub
if ! command -v stylua >/dev/null 2>&1; then
  if command -v cargo >/dev/null 2>&1; then
    info "Installing stylua via cargo..."
    cargo install stylua
  else
    info "Installing stylua from GitHub releases..."
    STYLUA_VERSION=$(curl -sL https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest \
      | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    curl -sL "https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VERSION}/stylua-linux-x86_64.zip" \
      -o /tmp/stylua.zip
    unzip -o /tmp/stylua.zip -d /tmp/stylua
    sudo mv /tmp/stylua/stylua /usr/local/bin/stylua
    rm -rf /tmp/stylua /tmp/stylua.zip
  fi
fi

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
link "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# ── Done ─────────────────────────────────────────────────────────────────────

info "Done. Start a new shell or run: source ~/.zshrc"
