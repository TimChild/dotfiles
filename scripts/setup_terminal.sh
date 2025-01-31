#!/bin/bash

# This script is to set up the terminal with configurations etc. saved in dotfiles.


# # Function that returns a boolean based on user input (y/n) (function should take prompt string, and default value)
# function get_boolean_input() {
#     local prompt=$1
#     local default=$2
#     local default_char
#     if [ "$default" = true ]; then
#         default_char="Y"
#     else
#         default_char="N"
#     fi
#     read -p "$prompt [$default_char]: " input
#     if [ -z "$input" ]; then
#         input=$default_char
#     fi
#     if [ "$input" = "Y" ] || [ "$input" = "y" ]; then
#         return 1
#     else
#         return 0
#     fi
# }


# Setup home directory configs
ln -s ~/dotfiles/home/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/home/.ssh/config ~/.ssh/config
ln -s ~/dotfiles/home/.zshrc ~/.zshrc


# Setup configs (that live in config directory)
ln -s ~/dotfiles/config/tmux ~/.config
ln -s ~/dotfiles/config/nvim ~/.config
ln -s ~/dotfiles/config/oh-my-zsh ~/.config
ln -s ~/dotfiles/config/alacritty ~/.config
# Setup clamav
sudo ln -s ~/dotfiles/config/clamav/freshclam.conf /usr/local/etc/freshclam.conf
sudo ln -s ~/dotfiles/config/clamav/clamd.conf /usr/local/etc/clamd.conf

# Install flatpack (package manager similar to snap) -- gnome plugin updates the "software" app
# # 2025-01-19 -- Both of these should only be used for gui apps (not cli)... Every time I've used them for something I access from cli, it has
# # caused be trouble (e.g. docker, pyenv, nvim, etc.)
sudo apt-get install -y flatpak gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Setup ufw firewall
# Install gui (gufw) and enable
sudo apt-get install -y gufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Update before any other installs
sudo apt-get update
# Install some general tools and utilities (required by tmux, nvim, etc.)
# For clipboard support in tmux (could also use xclip)
sudo apt-get install -y xsel
# Other tools that are useful
sudo apt-get install -y gcc ripgrep fd-find make curl unzip libfuse2 htop lm-sensors tree entr
# fd-find (fd) is a faster alternative to find (used by treesitter) -- needs link setup to use via fd
sudo ln -s $(which fdfind) ~/.local/bin/fd

# Setup alacritty terminal (not installing from snap doesn't work as default terminal)
sudo apt-get install alacritty
# Set as default terminal
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
# install terminfo for alcritty (only if not already installed)
infocmp alacritty &> /dev/null || (wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info && tic -xe alacritty,alacritty-direct alacritty.info && rm alacritty.info)

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
sudo apt-get install tmux
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# Setup Taskfile
# For taskfile (classic confinement required)
sudo snap install task --classic

# Setup pyenv
curl https://pyenv.run | bash
sudo apt-get install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Setup pipx
sudo apt-get install pipx
pipx ensurepath
sudo pipx ensurepath --global

# Install GitGuardian
pipx install ggshield
ggshield auth login

# Setup poetry
pipx install poetry
mkdir "$ZSH_CUSTOM/plugins/poetry"
poetry completions zsh > "$ZSH_CUSTOM"/plugins/poetry/_poetry
poetry self add poetry-plugin-export

# Install npm (with nvm as a version manager_
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# shellcheck source=/home/tim/.zshrc
source ~/.zshrc
nvm install node

# Install neovim (and setup custom config)
# curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
curl -LO https://github.com/neovim/neovim/releases/download/latest/nvim.appimage
chmod u+x nvim.appimage
sudo rm -rf /opt/nvim  # Remove any existing nvim directory
sudo mkdir -p /opt/nvim
sudo mv nvim.appimage /opt/nvim/nvim

# Install ruff (for python linting and lsp)
curl -LsSf https://astral.sh/ruff/install.sh | sh

# Install go
source ~/dotfiles/scripts/setup_go.sh

# Install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

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
echo "let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']" >> ~/.ideavimrc

# Install antivirus (clamav) (config files already copied)
sudo apt-get install -y clamav clamav-daemon
sudo groupadd clamav
sudo useradd -g clamav -s /bin/false -c "Clam Antivirus" clamav
sudo chown -R clamav:clamav /usr/local/share/clamav
sudo touch /var/log/freshclam.log
sudo chmod 600 /var/log/freshclam.log
sudo chown clamav:clamav /var/log/freshclam.log
# Run freshclam to update virus definitions
sudo freshclam
# Add cron job to update virus definitions (23 is random minute to avoid conflicts)
(sudo crontab -u clamav -l 2>/dev/null; echo "23 * * * * /usr/local/bin/freshclam") | sudo crontab -u clamav -
# TODO: Still need to figure out something about setup (sudo clamtop returns and error even after starting clamd, also does clamd need to be started by crontab on startup?)
# https://docs.clamav.net/manual/Usage/Scanning.html
# Start running clamav daemon
sudo clamd 


# Install Digital Ocean CLI
wget https://github.com/digitalocean/doctl/releases/download/v1.120.1/doctl-1.120.1-linux-amd64.tar.gz
tar xf doctl-1.120.1-linux-amd64.tar.gz
sudo mv doctl /usr/local/bin
rm doctl-1.120.1-linux-amd64.tar.gz
# Setut doctl auth
# echo "Running doctl auth init... You'll need to login to Digital Ocean and follow instructions"
# doctl auth init
# # Setup ssh key for doctl
# doctl compute ssh-key import $(whoami)-auto-script --public-key-file ~/.ssh/id_ed25519.pub


# Echo the contents of manual-steps.txt to terminal
cat ~/dotfiles/scripts/manual-steps.txt

