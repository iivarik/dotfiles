#!/bin/bash

if [ -x "$(command -v lazygit)" ]; then
  echo "lazygit already installed. Skipping install."
  exit 0
fi

CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Checking for latest version for lazygit."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

echo "Downloading lazygit $LAZYGIT_VERSION."
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

echo "Unpacking lazygit."
tar xf lazygit.tar.gz lazygit

echo "Installing lazygit."
sudo install lazygit /usr/local/bin

echo "Cleaning up installation files."
cd "$CUR_DIR"
rm -rf "$TMP_DIR"
