# Neovim Configuration

A comprehensive, portable Neovim configuration designed for efficient development across multiple environments.

## Installation

### Quick Start

Clone the repository to a working directory — this is where you edit the config:

```bash
git clone https://github.com/kremeshnoi/nvim-config ~/dev/nvim-config
```

Run the installer. It installs Neovim (latest stable), all language toolchains
required by the LSP/formatter setup, build tools, a Nerd Font, and the `rmnvim`
helper:

```bash
cd ~/dev/nvim-config
./install.sh
```

> **Supported platforms:** macOS (via Homebrew) and Ubuntu (via apt).
> Other Linux distributions are not currently supported by the installer —
> install dependencies manually if you're on something else.

Apply the config and start Neovim:

```bash
rmnvim
nvim
```

On first launch, Lazy.nvim bootstraps plugins, Mason installs LSP servers and
formatters, Treesitter installs parsers. Leave nvim open for a minute while
this finishes.

### Workflow

Edits in `~/dev/nvim-config/` do **not** apply to Neovim automatically.
After changing the config:

```bash
rmnvim
```

This re-syncs the repo into `~/.config/nvim` and wipes plugin/state/cache
data so Neovim reloads cleanly on next launch.

## Uninstallation

To completely remove this configuration and all associated data:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
rm -rf ~/.config/nvim
```

## Structure

```
~/dev/nvim-config/       # edit here
├── init.lua
├── install.sh           # installs nvim + all toolchains (macOS / Ubuntu)
├── lua/
│   ├── config/          # options/keymaps/autocmds + Lazy.nvim bootstrap
│   └── plugins/         # plugin specs and configuration (Lazy.nvim)
├── after/
│   └── queries/         # Treesitter query overrides
└── README.md

~/.config/nvim/          # populated by `rmnvim` — do not edit here
```
