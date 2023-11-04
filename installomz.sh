#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to prompt user for input
prompt_user() {
    read -p "$1: " val
    echo $val
}

# Update the package list and install necessary packages
sudo apt-get update && sudo apt-get install -y curl wget git zsh gh mc

# Setup Git
git config --global user.name "$(prompt_user 'Enter your name')"
git config --global user.email "$(prompt_user 'Enter your email')"

# Set your preferred editor for Git
git config --global core.editor "nano"

# Install Oh My Zsh if not already installed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install atuin
if ! command -v atuin &> /dev/null; then
    curl -fsSL https://install.atuin.sh | sh
fi

# Create a custom plugin for atuin in Oh My Zsh
ATUIN_PLUGIN_PATH="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/atuin"
mkdir -p $ATUIN_PLUGIN_PATH
echo -e "fpath+=( $ATUIN_PLUGIN_PATH )\nsource $ATUIN_PLUGIN_PATH/atuin.plugin.zsh" > $ATUIN_PLUGIN_PATH/atuin.plugin.zsh

# Install zsh-autosuggestions plugin
ZSH_AUTO_SUGGESTIONS_PATH="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [[ ! -d $ZSH_AUTO_SUGGESTIONS_PATH ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_AUTO_SUGGESTIONS_PATH
fi

# Install zsh-syntax-highlighting plugin
ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [[ ! -d $ZSH_SYNTAX_HIGHLIGHTING_PATH ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_SYNTAX_HIGHLIGHTING_PATH
fi

# Add zsh-syntax-highlighting and ensure zsh-autosuggestions is the last plugin in .zshrc
if ! grep -q 'zsh-syntax-highlighting zsh-autosuggestions' ~/.zshrc ; then
    sed -i.bak 's/plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
fi

# Switch to zsh for the current user in WSL
echo "if [ -t 1 ]; then" >> ~/.bashrc
echo "  exec zsh" >> ~/.bashrc
echo "fi" >> ~/.bashrc
