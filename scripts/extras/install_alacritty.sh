#!/bin/bash

CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Installing dependencies for Rust."
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y

echo "Installing Rust."
sudo curl https://sh.rustup.rs -sSf | sh

echo "Installing vivid."
sudo dpkg -i vivid_0.8.0_amd64.deb

echo "Cloning alacritty source files."
git clone https://github.com/jwilm/alacritty.git

echo "Building alacritty."
cd alacritty
cargo build --release

echo "Installing alacritty."
sudo cp target/release/alacritty /usr/local/bin/
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

echo "Installing ZSH completions for alacritty."
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

echo "Cleaning up installation files."

cd "$CUR_DIR"
rm -rf "$TMP_DIR"

ALACRITTY_VERSION=$(alacritty --version)

echo "alacritty installation completed."
echo "alacritty version: ${ALACRITTY_VERSION}"
