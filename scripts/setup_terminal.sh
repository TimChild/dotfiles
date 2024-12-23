#!/bin/bash

# This script is to set up the terminal with configurations etc. saved in dotfiles.


# For clipboard support in tmux (could also use xclip)
sudo apt-get update
sudo apt-get install xsel

# Setup home directory configs
ln -s ~/dotfiles/home/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/home/.ssh/config ~/.ssh/config

# Setup configs (that live in config directory)
ln -s ~/dotfiles/config/tmux ~/.config
ln -s ~/dotfiles/config/nvim ~/.config




