#!/usr/bin/env bash
set -euo pipefail

# install.sh - Install Neovim on GitHub Codespaces (Ubuntu/Debian)

if command -v nvim >/dev/null 2>&1; then
  echo "Neovim is already installed: $(nvim --version | head -n 1)"
  exit 0
fi

sudo apt-get update
sudo apt-get install -y neovim

echo "Neovim installation complete. Run 'nvim' to start."