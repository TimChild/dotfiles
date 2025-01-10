#!/bin/bash

# This script is to set up the terminal with configurations etc. saved in dotfiles.


# Setup home directory configs
ln -s ~/dotfiles/home/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/home/.ssh/config ~/.ssh/config
ln -s ~/dotfiles/home/.zshrc ~/.zshrc

# Setup configs (that live in config directory)
ln -s ~/dotfiles/config/tmux ~/.config
ln -s ~/dotfiles/config/nvim ~/.config
ln -s ~/dotfiles/config/oh-my-zsh ~/.config
ln -s ~/dotfiles/config/alacritty ~/.config

# Update before any other installs
sudo apt-get update
# Install some general tools and utilities (required by tmux, nvim, etc.)
# For clipboard support in tmux (could also use xclip)
sudo apt-get install -y xsel
# Other tools that are useful
sudo apt-get install -y gcc ripgrep make curl unzip

# Setup alacritty terminal (not installing from snap doesn't work as default terminal)
sudo apt-get install alacritty
# Set as default terminal
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50

# Install jetbrains nerdfont
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip -P ~/Downloads
mkdir ~/.fonts
unzip ~/Downloads/JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
rm ~/Downloads/JetBrainsMono.zip


# Install zsh (and oh-my-zsh -- asks to set as default)
sudo apt install zsh
ln -s ~/dotfiles/home/.zshrc ~/.zshrc
rm -rf ~/.oh-my-zsh
sh -c "$(wget -qO- https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --keep-zshrc --unattended
# --unattended (could add this to the ohmyzsh script to prevent trying to switch shells straight away)
rm -r ~/.oh-my-zsh/custom
ln -s ~/dotfiles/config/oh-my-zsh-custom ~/.oh-my-zsh/custom
# # Change the default shell (this might not be necessary following script above)
# # Note: Only takes effect on restart
chsh -s $(which zsh)
echo "Default shell change to zsh will be recognized after restart"


# Setup tmux
sudo snap install tmux --classic
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Setup Taskfile
# For taskfile (classic confinement required)
sudo snap install task --classic

# Setup pyenv
curl https://pyenv.run | bash

# Setup pipx
sudo apt-get install pipx
pipx ensurepath
sudo pipx ensurepath --global

# Setup poetry
pipx install poetry
mkdir "$ZSH_CUSTOM/plugins/poetry"
poetry completions zsh > "$ZSH_CUSTOM"/plugins/poetry/_poetry

# Install npm (with nvm as a version manager_
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# shellcheck source=/home/tim/.zshrc
source ~/.zshrc
nvm install node

# Install neovim (and setup custom config)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz   

# Install ruff (for python linting and lsp)
curl -LsSf https://astral.sh/ruff/install.sh | sh

# Install go
source ~/dotfiles/scripts/setup_go.sh

# Install github desktop
# https://github.com/shiftkey/desktop#installation-via-package-manager
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
sudo apt update && sudo apt install github-desktop

# Install github copilot in cli
gh extension install github/copilot

# Install docker (and docker-compose)
source ~/dotfiles/scripts/setup_docker.sh

# Setup gnome-tweaks
# Note: This installs the gui to make it easier to see/explore additional settings. The settings below will work regardless.
sudo apt-get install gnome-tweaks
# super + right click to resize windows (instead of super + middle click)
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true

# Enable vim quickscope in pycharm
# create a file ~/.ideavimrc with the following contents
# set quickscope
echo "set quickscope" > ~/.ideavimrc

# Echo the contents of manual-steps.txt to terminal
cat ~/dotfiles/scripts/manual-steps.txt

