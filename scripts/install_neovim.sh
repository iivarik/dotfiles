#!/usr/bin/bash

if [ -x "$(command -v nvim)" ]; then
  echo "nvim already installed. Skipping install."
  exit 0
fi

INSTALL_DIR=/opt/nvim
BIN_DIR=/usr/bin
CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Downloading latest neovim.appimage."
wget -q https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x ./nvim.appimage

echo "Extracting neovim.appimage."
./nvim.appimage --appimage-extract > /dev/null 2>&1

echo "Installing nvim to ${INSTALL_DIR}."
sudo rm -rf ${INSTALL_DIR}
sudo mkdir -p ${INSTALL_DIR}
sudo mv squashfs-root/* ${INSTALL_DIR}
sudo ln -sf ${INSTALL_DIR}/AppRun ${BIN_DIR}/nvim

echo "Cleaning up installation files."
cd "$CUR_DIR"
rm -rf "$TMP_DIR"

NVIM_VERSION=`$BIN_DIR/nvim --version | head -n1`

echo "Neovim installation completed."
echo "Neovim version: ${NVIM_VERSION}"
