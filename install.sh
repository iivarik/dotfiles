#!/usr/bin/env bash
# Usage: ./install.sh [packages|nvim|links|shell]...   (no args = all, in that order)
# Safe to re-run: every step skips what is already done.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Neovim isn't taken from apt so the version matches the pinned plugins.
# Bump deliberately, together with :Lazy update.
NVIM_VERSION="v0.12.5"

APT_PACKAGES=(
  zsh tmux git curl unzip build-essential
  zsh-autosuggestions zsh-syntax-highlighting
  ripgrep fd-find fzf bat eza vivid lazygit gh
  nodejs npm tree-sitter-cli   # for LazyVim: Mason LSPs, treesitter parsers
)

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

install_packages() {
  step "apt packages"
  sudo apt-get update
  sudo apt-get install -y "${APT_PACKAGES[@]}"

  # Debian/Ubuntu rename some binaries; expose the usual names
  mkdir -p ~/.local/bin
  command -v fd >/dev/null || ln -sf "$(command -v fdfind)" ~/.local/bin/fd
  command -v bat >/dev/null || ln -sf "$(command -v batcat)" ~/.local/bin/bat
}

install_nvim() {
  step "neovim ${NVIM_VERSION}"
  if command -v nvim >/dev/null && nvim --version | head -n1 | grep -q "${NVIM_VERSION}$"; then
    echo "already installed"
    return
  fi
  local arch tmp
  arch="$(uname -m)"
  [[ "$arch" == "aarch64" ]] && arch="arm64"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/nvim.tar.gz" \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${arch}.tar.gz"
  sudo rm -rf "/opt/nvim-linux-${arch}"
  sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
  sudo ln -sf "/opt/nvim-linux-${arch}/bin/nvim" /usr/local/bin/nvim
  rm -rf "$tmp"
  nvim --version | head -n1
}

link() {
  local src="$DOTFILES/$1" dest="$HOME/$2"
  if [[ "$(readlink "$dest" 2>/dev/null)" == "$src" ]]; then
    echo "ok      ~/$2"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    local backup="$dest.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$dest" "$backup"
    echo "backup  ~/$2 -> $backup"
  fi
  ln -s "$src" "$dest"
  echo "linked  ~/$2"
}

install_links() {
  step "config symlinks"
  link .zshrc                   .zshrc
  link .config/tmux             .config/tmux
  link .config/nvim             .config/nvim

  # Own hosts go in ~/.ssh/config.d/ (untracked); sockets/ is for connection reuse
  mkdir -p ~/.ssh/config.d ~/.ssh/sockets
  chmod 700 ~/.ssh ~/.ssh/config.d ~/.ssh/sockets
  link .ssh/config              .ssh/config
}

install_shell() {
  step "login shell"
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$zsh_path" ]]; then
    echo "already zsh"
  else
    chsh -s "$zsh_path"
  fi
}

steps=("$@")
[[ ${#steps[@]} -eq 0 ]] && steps=(packages nvim links shell)
for s in "${steps[@]}"; do
  case "$s" in
    packages|nvim|links|shell) "install_$s" ;;
    *) echo "unknown step: $s" >&2; exit 1 ;;
  esac
done

step "done"
[[ " ${steps[*]} " == *" links "* ]] && echo "Open nvim once to let lazy.nvim restore the pinned plugins (:Lazy restore)."
