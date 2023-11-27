#!/usr/bin/bash

if [ -x "$(command -v vivid)" ]; then
  echo "vivid already installed. Skipping install."
  exit 0
fi

CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Downloading vivid release from GitHub."
wget -q https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb

echo "Installing vivid."
sudo dpkg -i vivid_0.8.0_amd64.deb

echo "Cleaning up installation files."

cd "$CUR_DIR"
rm -rf "$TMP_DIR"

VIVID_VERSION=`vivid --version`

echo "vivid installation completed."
echo "vivid version: ${VIVID_VERSION}"
