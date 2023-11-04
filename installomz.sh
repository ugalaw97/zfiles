#!/bin/bash

# Update the package list and install necessary packages
sudo apt-get update && sudo apt-get install -y curl wget git zsh

# Setup Git (replace with your own name and email)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Optionally, set your preferred editor for Git
# git config --global core.editor "nano"

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install atuin
curl -fsSL https://install.atuin.sh | sh

# Create a custom plugin for atuin in Oh My Zsh
echo -e "fpath+=( ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/atuin )\nsource ${(ZSH_CUSTOM:-~/.oh-my-zsh/custom)/plugins/atuin/atuin.plugin.zsh}" > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/atuin/atuin.plugin.zsh

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Add zsh-syntax-highlighting and ensure zsh-autosuggestions is the last plugin in .zshrc
sed -i.bak 's/plugins=(\(.*\))/plugins=(\1 zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

# Optionally, switch to zsh for the current user in WSL by adding the following line to the end of ~/.bashrc
echo "if [ -t 1 ]; then" >> ~/.bashrc
echo "  exec zsh" >> ~/.bashrc
echo "fi" >> ~/.bashrc
