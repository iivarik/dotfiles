#!/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

function install_file() {
    local SOURCE_FILE="$1"
    local DEST_FILE="$2"

    local DEST_DIR=`dirname "$DEST_FILE"`
    mkdir -p "$DEST_DIR"

    if [ -e "${DEST_FILE}" ]; then
        local TIMESTAMP=`date +%F-%T`
        local BACKUP_FILE="${DEST_FILE}.bak_${TIMESTAMP}"
        echo "Backing up ${DEST_FILE} to ${BACKUP_FILE}."
        mv "${DEST_FILE}" "${BACKUP_FILE}"
    fi

    echo "Installing ${SOURCE_FILE} to ${DEST_FILE}"
    ln -sf "${SOURCE_FILE}" "${DEST_FILE}"
}

echo "Installing configuration files."
install_file ${PROJECT_ROOT}/.zshrc ~/.zshrc
install_file ${PROJECT_ROOT}/.tmux.conf ~/.tmux.conf
install_file ${PROJECT_ROOT}/.tmux.remote.conf ~/.tmux.remote.conf
install_file ${PROJECT_ROOT}/.config/tmux/catppuccin/keys_enabled.sh ~/.tmux/plugins/tmux/custom/keys_enabled.sh 
install_file ${PROJECT_ROOT}/.config/tmux/catppuccin/temp.sh ~/.tmux/plugins/tmux/custom/temp.sh 
install_file ${PROJECT_ROOT}/.config/nvim ~/.config/nvim

echo "Changing login shell to zsh."
chsh --shell `which zsh` `whoami`
