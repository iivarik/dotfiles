#!/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

function install_file() {
    local SOURCE_FILE="$1"
    local DEST_FILE="$2"

    echo "Installing ${SOURCE_FILE} to ${DEST_FILE}"
    ln -sf "${SOURCE_FILE}" "${DEST_FILE}"
}

echo "Installing prerequisites"
sudo apt update
sudo apt install -y npm zsh tmux ripgrep unzip git

# Install oh-my-zsh
echo "Installing Oh My Zsh"
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

zsh "${PROJECT_ROOT}/scripts/install_exa.sh"
zsh "${PROJECT_ROOT}/scripts/install_neovim.sh"
zsh "${PROJECT_ROOT}/scripts/install_bat.sh"
zsh "${PROJECT_ROOT}/scripts/install_vivid.sh"

install_file ${PROJECT_ROOT}/.zshrc ~/.zshrc
install_file ${PROJECT_ROOT}/.tmux.conf ~/.tmux.conf

echo "Changing login shell to zsh."
sudo chsh --shell `which zsh` `whoami`
