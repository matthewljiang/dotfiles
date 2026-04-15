# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository targeting GitHub Codespaces (Ubuntu/Debian). Contains:
- **`.zshrc`** — Oh My Zsh config with `devcontainers` theme and `git` plugin; auto-updates disabled
- **`.vimrc`** — Minimal Vim config (space leader, 4-space tabs, relative numbers)
- **`.config/nvim/`** — Neovim config based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- **`install.sh`** — Bootstrap script to install Neovim, npm/nodejs, python3-pip on Codespaces

## Setup

Run `install.sh` to bootstrap a new Codespaces environment:
```sh
bash install.sh
```

This installs Neovim, npm, nodejs, and python3-pip via `apt-get`, then clones kickstart.nvim into `~/.config/nvim`.

> Note: `install.sh` is intended for GitHub Codespaces (Ubuntu). It does **not** symlink the dotfiles — that wiring is handled by Codespaces' dotfiles feature automatically.

## Neovim Configuration Architecture

The Neovim config (`~/.config/nvim/`) follows the kickstart.nvim layout:

- **`init.lua`** — Single-file core config. Sets options, keymaps, and bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim). All plugins are declared here unless split into the directories below.
- **`lua/kickstart/plugins/`** — Optional built-in plugin configs from kickstart (autopairs, debug, gitsigns, indent_line, lint, neo-tree). These are opt-in; uncomment their `require` calls in `init.lua` to enable.
- **`lua/custom/plugins/init.lua`** — The correct place to add new personal plugins. Returns a `LazySpec` table. This file will never have merge conflicts with upstream kickstart.

**Leader key:** `<Space>` (set in `init.lua` before lazy loads)

**Nerd Font:** disabled by default (`vim.g.have_nerd_font = false`)

## Lua Formatting

All Lua files use [StyLua](https://github.com/JohnnyMorganz/StyLua). Config is in `.config/nvim/.stylua.toml`:

```
column_width = 160
indent_type = Spaces, width = 2
quote_style = AutoPreferSingle
call_parentheses = None
collapse_simple_statement = Always
```

Format a file:
```sh
stylua .config/nvim/init.lua
```

Format all Lua in the nvim config:
```sh
stylua .config/nvim/
```

## Adding Plugins

Add plugins to `lua/custom/plugins/init.lua` as entries in the returned `LazySpec` table, or create new `.lua` files in `lua/custom/plugins/` (lazy.nvim auto-discovers them). Do not edit `lua/kickstart/plugins/` files for personal customizations.
