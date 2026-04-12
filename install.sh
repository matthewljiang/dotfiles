#!/bin/bash

set -euo pipefail

# install.sh - Install Neovim on GitHub Codespaces (Ubuntu/Debian)

if command -v nvim >/dev/null 2>&1; then
  echo "Neovim is already installed: $(nvim --version | head -n 1)"
else
  echo "Neovim not found. Installing..."
  sudo apt-get update
  sudo apt-get install -y neovim
fi

def kickstart_version() {
  local version
  version=$(curl -sL https://api.github.com/repos/nvim-lua/kickstart.nvim/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  echo "$version"
}

sudo apt-get install -y npm nodejs
sudo apt-get install -y python3-pip

if command -v git >/dev/null 2>&1; then

  git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
else
  echo "Git not found. Installing..."
  sudo apt-get install -y git
fi
