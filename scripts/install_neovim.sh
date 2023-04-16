#!/usr/bin/bash

BIN_DIR=/usr/local/bin
CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Downloading latest neovim.appimage."
wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x ./nvim.appimage

echo "Extracting neovim.appimage."
./nvim.appimage --appimage-extract > /dev/null 2>&1

echo "Installing nvim to ${BIN_DIR}."
sudo mv ./squashfs-root/usr/bin/nvim "${BIN_DIR}"

echo "Cleaning up installation files."
cd "$CUR_DIR"
rm -rf "$TMP_DIR"

NVIM_VERSION=`$BIN_DIR/nvim --version | head -n1`

echo "Neovim installation completed."
echo "Neovim version: ${NVIM_VERSION}"
