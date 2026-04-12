#!/usr/bin/env bash
set -euo pipefail

# install.sh - Install Neovim on GitHub Codespaces (Ubuntu/Debian)

if command -v nvim >/dev/null 2>&1; then
  echo "Neovim is already installed: $(nvim --version | head -n 1)"
else
  echo "Neovim not found. Installing..."
  sudo apt-get update
  sudo apt-get install -y neovim
fi


echo "Neovim installation complete. Run 'nvim' to start."