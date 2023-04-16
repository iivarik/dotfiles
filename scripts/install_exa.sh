#!/usr/bin/bash

BIN_DIR=/usr/local/bin
ZSH_COMPLETIONS_DIR=/usr/local/share/zsh/site-functions
MAN_DIR=/usr/share/man
CUR_DIR=$(pwd)
TMP_DIR=$(mktemp -d)

cd "$TMP_DIR"

echo "Downloading exa release from GitHub."
wget -q https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip

echo "Extracting exa release package."
unzip -q exa-linux-x86_64-v0.10.1.zip

echo "Installing binary to ${BIN_DIR}."
sudo mv ./bin/exa "${BIN_DIR}"

echo "Installing completions to ${ZSH_COMPLETIONS_DIR}."
sudo mv ./completions/exa.zsh "${ZSH_COMPLETIONS_DIR}"

echo "Installing manpages to ${MAN_DIR}."
sudo mv ./man/exa.1 "${MAN_DIR}/man1"
sudo mv ./man/exa_colors.5 "${MAN_DIR}/man5"

echo "Cleaning up installation files."
cd "$CUR_DIR"
rm -rf "$TMP_DIR"

EXA_VERSION=`$BIN_DIR/exa --version | head -n2 | tail -n1`

echo "exa installation completed."
echo "exa version: ${EXA_VERSION}"
