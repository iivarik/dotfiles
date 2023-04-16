#!/usr/bin/bash

CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Downloading bat release from GitHub."
wget -q https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-musl_0.23.0_amd64.deb

echo "Installing bat."
sudo dpkg -i bat-musl_0.23.0_amd64.deb

echo "Cleaning up installation files."

cd "$CUR_DIR"
rm -rf "$TMP_DIR"

BAT_VERSION=`bat --version`

echo "bat installation completed."
echo "bat version: ${BAT_VERSION}"
