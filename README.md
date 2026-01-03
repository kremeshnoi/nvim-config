# Neovim Configuration

A comprehensive, portable Neovim configuration designed for efficient development across multiple environments.

<img width="3839" height="2085" alt="image" src="https://github.com/user-attachments/assets/497e8b49-081e-4993-be9e-31f3b7684793" />

## Dependencies

### Core

- **Neovim (0.11.4)**: https://github.com/neovim/neovim/wiki/Installing-Neovim
- **Git** (Lazy.nvim bootstrap + git plugins): https://git-scm.com/downloads
- **Nerd Font** (icons via `nvim-web-devicons`): https://www.nerdfonts.com/

### Mason

#### Utilities

- **curl**: https://curl.se/docs/install.html
- **wget** (optional alternative): https://www.gnu.org/software/wget/
- **unzip**: https://infozip.sourceforge.net/UnZip.html
- **tar**: https://www.gnu.org/software/tar/
- **gzip**: https://www.gnu.org/software/gzip/

#### Languages

- luarocks: /usr/local/bin/luarocks 3.12.2
- cargo: cargo 1.88.0 (873a06493 2025-05-10)
- PHP: PHP 8.4.16 (cli) (built: Dec 18 2025 23:38:28) (NTS)
- Go: go version go1.25.5 linux/amd64
- node: v24.8.0
- Composer: Composer version 2.9.3 2025-12-30 13:40:17
- Ruby: ruby 3.4.7 (2025-10-08 revision 7a5688e2a2) +PRISM x86_64-linux
- julia: julia version 1.10.0
- python: Python 3.10.12
- java: openjdk version "17.0.17" 2025-10-21
- npm: 11.6.0
- RubyGem: 3.6.9
- javac: javac 17.0.17
- pip: pip 22.0.2 from /usr/lib/python3/dist-packages/pip (python 3.10)
- python venv: O

### Telescope

- **ripgrep (`rg`)**: https://github.com/BurntSushi/ripgrep#installation
- **fd (`fd`)**: https://github.com/sharkdp/fd#installation

### Treesitter

#### Build prerequisites

To build Treesitter parsers locally:

- **C compiler** (gcc or clang): https://gcc.gnu.org/ or https://clang.llvm.org/
- **make**: https://www.gnu.org/software/make/

For an ideal Treesitter health report:

- **tree-sitter CLI**: https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli

#### Languages

```txt
                        H L F I J
- bash                  ✓ ✓ ✓ ✓ ✓
- clojure               ✓ ✓ ✓ . ✓
- comment               ✓ . . . .
- css                   ✓ . ✓ ✓ ✓
- csv                   ✓ . . . .
- dockerfile            ✓ . . . ✓
- dot                   ✓ . ✓ ✓ ✓
- ecma
- gitattributes         ✓ ✓ . . ✓
- gitcommit             ✓ . . . ✓
- gitignore             ✓ . . . ✓
- hcl                   ✓ . ✓ ✓ ✓
- html                  ✓ ✓ ✓ ✓ ✓
- html_tags
- http                  ✓ . ✓ . ✓
- javascript            ✓ ✓ ✓ ✓ ✓
- jsdoc                 ✓ . . . .
- json                  ✓ ✓ ✓ ✓ ✓
- jsx
- lua                   ✓ ✓ ✓ ✓ ✓
- luadoc                ✓ . . . .
- make                  ✓ . ✓ . ✓
- markdown              ✓ . ✓ ✓ ✓
- markdown_inline       ✓ . . . ✓
- mermaid               ✓ . ✓ ✓ ✓
- nginx                 ✓ . ✓ . ✓
- php                   ✓ ✓ ✓ ✓ ✓
- php_only              ✓ ✓ ✓ ✓ ✓
- phpdoc                ✓ . . . .
- regex                 ✓ . . . .
- ruby                  ✓ ✓ ✓ ✓ ✓
- rust                  ✓ ✓ ✓ ✓ ✓
- scheme                ✓ . ✓ . ✓
- scss                  ✓ . ✓ ✓ ✓
- sql                   ✓ . ✓ ✓ ✓
- toml                  ✓ ✓ ✓ ✓ ✓
- tsv                   ✓ . . . .
- tsx                   ✓ ✓ ✓ ✓ ✓
- typescript            ✓ ✓ ✓ ✓ ✓
- vim                   ✓ ✓ ✓ . ✓
- vimdoc                ✓ . . . ✓
- vue                   ✓ . ✓ ✓ ✓
- yaml                  ✓ ✓ ✓ ✓ ✓
```

## Structure

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── config/          # options/keymaps/autocmds + Lazy.nvim bootstrap
│   └── plugins/         # plugin specs and configuration (Lazy.nvim)
└── README.md
```
