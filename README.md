# Neovim Configuration

A comprehensive, portable Neovim configuration designed for efficient development across multiple environments.

## Overview

This repository contains a carefully crafted Neovim configuration that provides a consistent, feature-rich development environment. The configuration emphasizes productivity, maintainability, and ease of deployment across different systems.

## Requirements

### Dependencies

- **Neovim**: Version 0.10.0 or higher ([Installation Guide](https://github.com/neovim/neovim/releases/tag/v0.10.0))
- **Nerd Font**: Required for proper icon rendering ([Download](https://www.nerdfonts.com/))
- **Python Virtual Environment**: python3.10-venv package
- **Ripgrep**: Enhanced grep searching functionality with Telescope ([Installation](https://github.com/BurntSushi/ripgrep))


## Installation

### Quick Start

Clone this repository directly into your Neovim configuration directory:

```bash
git clone https://github.com/kremeshnoi/nvim-config ~/.config/nvim
```

## Uninstallation

To completely remove this configuration and all associated data:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.config/nvim
```

## Directory Structure
```
~/.config/nvim/
├── init.lua             # Main configuration entry point
├── lua/
│   ├── config/          # Core configuration files
│   └── plugins/         # Plugin configurations
└── README.md            # This file
```