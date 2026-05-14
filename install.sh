#!/usr/bin/env bash
set -euo pipefail

# Bootstrap script for this Neovim config.
# Supported: macOS (Homebrew) and Ubuntu (apt).
# Installs: nvim (latest), all language toolchains, build tools,
# Nerd Font, and the rmnvim helper.

log()  { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

OS=""

detect_os() {
  case "$(uname -s)" in
    Darwin) OS=macos ;;
    Linux)
      if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        if [[ "${ID:-}" == "ubuntu" || "${ID_LIKE:-}" == *"debian"* ]]; then
          OS=ubuntu
        fi
      fi
      ;;
  esac

  if [ -z "$OS" ]; then
    err "Unsupported OS. This script supports macOS and Ubuntu only."
    exit 1
  fi
  log "Detected OS: $OS"
}

ensure_pkg_manager() {
  if [ "$OS" = "macos" ]; then
    if ! have brew; then
      log "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    fi
  else
    log "Updating apt cache..."
    sudo apt-get update -qq
  fi
}

install_basics() {
  log "Installing core utilities..."
  if [ "$OS" = "macos" ]; then
    brew install git curl wget gnu-tar gzip ripgrep fd
  else
    sudo apt-get install -y -qq \
      git curl wget unzip tar gzip build-essential pkg-config \
      ripgrep fd-find ca-certificates gnupg
    if ! have fd && have fdfind; then
      sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
    fi
  fi
}

install_neovim() {
  if have nvim; then
    log "Neovim already installed: $(nvim --version | head -1)"
    return
  fi
  log "Installing Neovim (latest stable)..."
  if [ "$OS" = "macos" ]; then
    brew install neovim
  else
    local arch
    arch=$(uname -m)
    case "$arch" in
      x86_64|aarch64) ;;
      *) err "Unsupported architecture: $arch"; exit 1 ;;
    esac
    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz"
    curl -fLo /tmp/nvim.tar.gz "$url"
    sudo rm -rf /opt/nvim "/opt/nvim-linux-${arch}"
    sudo tar -C /opt -xzf /tmp/nvim.tar.gz
    sudo mv "/opt/nvim-linux-${arch}" /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    rm /tmp/nvim.tar.gz
  fi
}

install_python() {
  if have python3; then
    log "Python already installed: $(python3 --version)"
  else
    log "Installing Python..."
    if [ "$OS" = "macos" ]; then
      brew install python
    else
      sudo apt-get install -y -qq python3 python3-pip python3-venv
    fi
  fi
}

install_node() {
  if have node; then
    log "Node already installed: $(node --version)"
    return
  fi
  log "Installing Node.js..."
  if [ "$OS" = "macos" ]; then
    brew install node
  else
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y -qq nodejs
  fi
}

install_rust() {
  if have cargo; then
    log "Rust already installed: $(cargo --version)"
    return
  fi
  log "Installing Rust (rustup)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  # shellcheck disable=SC1091
  . "$HOME/.cargo/env"
}

install_go() {
  if have go; then
    log "Go already installed: $(go version)"
    return
  fi
  log "Installing Go..."
  if [ "$OS" = "macos" ]; then
    brew install go
  else
    local go_ver
    go_ver=$(curl -fsSL https://go.dev/VERSION?m=text | head -1)
    local arch
    arch=$(uname -m)
    case "$arch" in
      x86_64) arch="amd64" ;;
      aarch64) arch="arm64" ;;
    esac
    curl -fLo /tmp/go.tar.gz "https://go.dev/dl/${go_ver}.linux-${arch}.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    if ! grep -q '/usr/local/go/bin' "$HOME/.profile" 2>/dev/null; then
      echo 'export PATH="$PATH:/usr/local/go/bin"' >> "$HOME/.profile"
    fi
    export PATH="$PATH:/usr/local/go/bin"
  fi
}

install_php() {
  if have php; then
    log "PHP already installed: $(php --version | head -1)"
  else
    log "Installing PHP..."
    if [ "$OS" = "macos" ]; then
      brew install php
    else
      sudo apt-get install -y -qq php-cli php-mbstring php-xml php-curl php-zip
    fi
  fi

  if have composer; then
    log "Composer already installed: $(composer --version)"
  else
    log "Installing Composer..."
    local expected actual
    expected=$(curl -fsSL https://composer.github.io/installer.sig)
    curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php
    actual=$(php -r "echo hash_file('sha384', '/tmp/composer-setup.php');")
    if [ "$expected" != "$actual" ]; then
      err "Composer installer checksum mismatch"
      rm /tmp/composer-setup.php
      exit 1
    fi
    sudo php /tmp/composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
    rm /tmp/composer-setup.php
  fi
}

install_ruby() {
  if have ruby; then
    log "Ruby already installed: $(ruby --version)"
    return
  fi
  log "Installing Ruby..."
  if [ "$OS" = "macos" ]; then
    brew install ruby
  else
    sudo apt-get install -y -qq ruby-full
  fi
}

install_java() {
  if have java; then
    log "Java already installed: $(java --version | head -1)"
    return
  fi
  log "Installing Java (JDK 17)..."
  if [ "$OS" = "macos" ]; then
    brew install openjdk@17
  else
    sudo apt-get install -y -qq default-jdk
  fi
}

install_julia() {
  if have julia; then
    log "Julia already installed: $(julia --version)"
    return
  fi
  log "Installing Julia (juliaup)..."
  curl -fsSL https://install.julialang.org | sh -s -- -y --default-channel release
  export PATH="$HOME/.juliaup/bin:$PATH"
}

install_luarocks() {
  if have luarocks; then
    log "LuaRocks already installed: $(luarocks --version | head -1)"
    return
  fi
  log "Installing LuaRocks..."
  if [ "$OS" = "macos" ]; then
    brew install luarocks
  else
    sudo apt-get install -y -qq luarocks
  fi
}

install_treesitter_cli() {
  if have tree-sitter; then
    log "tree-sitter CLI already installed: $(tree-sitter --version)"
    return
  fi
  log "Installing tree-sitter CLI..."
  if [ "$OS" = "macos" ]; then
    brew install tree-sitter
  else
    cargo install tree-sitter-cli
  fi
}

install_nerd_font() {
  log "Installing Nerd Font (FiraCode)..."
  if [ "$OS" = "macos" ]; then
    brew install --cask font-fira-code-nerd-font || warn "Cask install failed (already installed?)"
  else
    local font_dir="$HOME/.local/share/fonts"
    local font_file="$font_dir/FiraCodeNerdFont-Regular.ttf"
    mkdir -p "$font_dir"
    if [ -f "$font_file" ]; then
      log "Nerd Font already installed"
      return
    fi
    curl -fLo "$font_file" \
      "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf"
    fc-cache -f >/dev/null
  fi
}

install_rmnvim() {
  log "Installing rmnvim helper..."
  sudo tee /usr/local/bin/rmnvim > /dev/null <<'EOF'
#!/usr/bin/env bash
REPO="$HOME/dev/nvim-config"
TARGET="$HOME/.config/nvim"

if [ -f "$TARGET/lazy-lock.json" ] && [ ! -L "$TARGET" ]; then
  echo "Saving lazy-lock.json back to repo..."
  cp "$TARGET/lazy-lock.json" "$REPO/lazy-lock.json"
fi

echo "Removing Neovim data directories..."
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

echo "Removing current Neovim config..."
rm -rf "$TARGET"
mkdir -p "$TARGET"

echo "Copying config from $REPO..."
cp -R "$REPO/." "$TARGET/"

echo "Neovim configuration reset complete!"
EOF
  sudo chmod +x /usr/local/bin/rmnvim
}

main() {
  detect_os
  ensure_pkg_manager
  install_basics
  install_python
  install_node
  install_rust
  install_go
  install_php
  install_ruby
  install_java
  install_julia
  install_luarocks
  install_neovim
  install_treesitter_cli
  install_nerd_font
  install_rmnvim

  log ""
  log "All dependencies installed."
  log "Next steps:"
  log "  1. Make sure this repo lives at ~/dev/nvim-config"
  log "  2. Run: rmnvim"
  log "  3. Run: nvim   (wait while Lazy/Mason/Treesitter bootstrap)"
  log ""
  log "If you installed Rust/Go/Julia, open a new shell or 'source ~/.profile'"
  log "to pick up updated PATH."
}

main "$@"
