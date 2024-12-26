#!/bin/bash

# This script is to set up the terminal with configurations etc. saved in dotfiles.


# # Setup home directory configs
# ln -s ~/dotfiles/home/.gitconfig ~/.gitconfig
# ln -s ~/dotfiles/home/.ssh/config ~/.ssh/config
# ln -s ~/dotfiles/home/.zshrc ~/.zshrc
# 
#
# # Setup configs (that live in config directory)
# ln -s ~/dotfiles/config/tmux ~/.config
# ln -s ~/dotfiles/config/nvim ~/.config
# ln -s ~/dotfiles/config/oh-my-zsh ~/.config

# Install zsh (and oh-my-zsh -- asks to set as default)
sudo apt install zsh
ln -s ~/dotfiles/home/.zshrc ~/.zshrc
rm -rf ~/.oh-my-zsh
sh -c "$(wget -qO- https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended --keep-zshrc
rm -r ~/.oh-my-zsh/custom
ln -s ~/dotfiles/config/oh-my-zsh-custom ~/.oh-my-zsh/custom


# For clipboard support in tmux (could also use xclip)
sudo apt-get update
sudo apt-get install xsel
# C-compilers (for some nvim things)
sudo apt-get install gcc
# Other tools that are useful
sudo apt-get install ripgrep make
# For taskfile (classic confinement required)
sudo snap install task --classic

# Install neovim (and setup custom config)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
git clone https://github.com/TimChild/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
# export PATH="$PATH:/opt/nvim-linux64/bin"  # Might need to add this to .zshrc?





