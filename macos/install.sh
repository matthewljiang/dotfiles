#!/bin/bash

set -euo pipefail

CONFIGS_URL="https://github.com/matthewljiang/dotfiles/releases/download/latest/macos.tar.gz"
CONFIGS_DIR="$(mktemp -d)"

# ── Helpers ───────────────────────────────────────────────────────────────────

info() { echo "[info]  $*"; }
warn() { echo "[warn]  $*"; }
error() {
  echo "[error] $*" >&2
  exit 1
}

# ── Download configs ──────────────────────────────────────────────────────────

info "Downloading configs..."
curl -fsSL "$CONFIGS_URL" | tar -xz -C "$CONFIGS_DIR"

# ── Homebrew ──────────────────────────────────────────────────────────────────

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Omachy ────────────────────────────────────────────────────────────────────

info "Installing omachy..."
brew tap dough654/omachy
brew install omachy
omachy install

# -- Home-row mappings ---------------------------------------------------------

brew tap wontaeyang/hrm
brew install --cask hrm

# ── Copy configs ──────────────────────────────────────────────────────────────

info "Copying configs..."
cp "$CONFIGS_DIR/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config"
cp -r "$CONFIGS_DIR/.config/." "$HOME/.config/"

# Remove ghostty's auto-created Application Support config so only ~/.config/ghostty is used
rm -f "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

rm -rf "$CONFIGS_DIR"

# ── Done ──────────────────────────────────────────────────────────────────────

info "Done. Start a new shell or run: source ~/.zshrc"
