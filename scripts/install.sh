#!/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Flags to track if a component is scheduled for installation
prerequisites_flag=false
oh_my_zsh_flag=false
tools_flag=false
config_flag=false
extras_flag=false

# Function definitions for each installation step
install_prerequisites() {
    echo "Installing prerequisites"
    sudo apt update
    sudo apt install -y npm zsh tmux ripgrep unzip git sysstat
}

install_oh_my_zsh() {
    echo "Installing Oh My Zsh"
    rm -rf ~/.oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_tools() {
    zsh "${PROJECT_ROOT}/scripts/install_exa.sh"
    zsh "${PROJECT_ROOT}/scripts/install_neovim.sh"
    zsh "${PROJECT_ROOT}/scripts/install_bat.sh"
    zsh "${PROJECT_ROOT}/scripts/install_vivid.sh"
    zsh "${PROJECT_ROOT}/scripts/install_lazygit.sh"
    zsh "${PROJECT_ROOT}/scripts/install_gh.sh"
}

install_config() {
    zsh "${PROJECT_ROOT}/scripts/install_config.sh"
}

install_extras() {
    zsh "${PROJECT_ROOT}/scripts/extras/install_alacritty.sh"
}

# Usage message
usage() {
    echo "Usage: $0 [--all|--config|--extras|--tools|--help]"
    exit 1
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    usage
fi

# First pass: Check arguments and set flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            if [ "$config_flag" = true ] || [ "$extras_flag" = true ] || [ "$tools_flag" = true ]; then
                usage
            fi
            prerequisites_flag=true
            oh_my_zsh_flag=true
            tools_flag=true
            config_flag=true
            extras_flag=true
            ;;
        --config)
            if [ "$config_flag" = true ]; then
                usage
            fi
            config_flag=true
            ;;
        --extras)
            if [ "$extras_flag" = true ]; then
                usage
            fi
            extras_flag=true
            ;;
        --tools)
            if [ "$tools_flag" = true ]; then
                usage
            fi
            tools_flag=true
            ;;
        --help)
            usage
            ;;
        *)
            echo "Invalid argument: $1"
            usage
            ;;
    esac
    shift
done

# Second pass: Perform installations based on flags
if [ "$prerequisites_flag" = true ]; then
    install_prerequisites
fi

if [ "$oh_my_zsh_flag" = true ]; then
    install_oh_my_zsh
fi

if [ "$tools_flag" = true ]; then
    install_tools
fi

if [ "$config_flag" = true ]; then
    install_config
fi

if [ "$extras_flag" = true ]; then
    install_extras
fi

