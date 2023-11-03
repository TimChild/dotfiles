# Setting up WSL2
After installing ubuntu 22.04


## Windows terminal settings
Go to settings, then probably need to add a new profile.

Select the Ubuntu with the penguin icon

Then under `Appearance`, set the Font face to a `Nerd Font`. I like `JetBrainsMono`. If this is not installed, follow instructions for installing the font on Windows.

This font will be used by the `terminal`, `tmux`, and `nvim` (and is necessary for the latter two)

## From the basic terminal

Run 
```
sudo apt update
sudo apt dist-upgrade
```
to get all the basics as up to date as possible

### SSH key

Generate a new ssh key, using I think:
```
ssh keygen
```
Don't set a password on it

Copy the `~/.ssh/id_rsa.pub` contents to add to `GitHub.com` to allow SSH accesss to repo
```
cat ~/.ssh/id_rsa.pub
```

Then clone the `dotfiles` repository

```
git clone git@github.com:TimChild/dotfiles.git
```

Then run:
```
~/dotfiles/scripts/symlink-setup.sh
```


## Tmux working again
I think `tmux` might already be installed by default? Then just need to clone the plugin manager.

```
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then, if in tmux already
```
tmux source ~/.config/tmux/tpm/tpm
```

And, to install the plugins if it doesn't automatically (in tmux)
```
<leader> + I (<ctrl>+<space> <shift><i>)
```


## Getting Neovim working
Download a 0.9.x version from 

https://github.com/neovim/neovim/releases
e.g.
```
wget https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz
```

Then Extract: 
```
tar xzvf nvim-linux64.tar.gz
```

And make a link to nvim in usr/bin/
```
sudo ln -s "$(pwd)/nvim-linux64/bin/nvim" /usr/local/bin/nvim
```

Also install a C compiler for some reason
```
sudo apt install gcc
```


## Installing docker

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt install docker-ce
```

Then, to allow running docker without `sudo`
```
sudo usermod -aG docker $USER
```


## Set up backups
Follow instructions in `~/backup-scripts/README.md`

Note: this is one of the folders that a link is created for from the dotfiles repo. 


