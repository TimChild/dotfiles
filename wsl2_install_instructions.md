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

To install `make`
```
sudo apt install make
```

Install `pipx` (I think this is effectively `pip` but installs in an isolated environment while maintaining access globally via cli)
```
sudo apt install pipx
pipx ensurepath
```

Then, potentially want to set up completions following `pipx completions` instructions, although that is probably done already because it's set in `.bashrc` or `.profile` that are part of this `dotfiles` repo.


Install `poetry` (A python package manager)
```
pipx install poetry
```



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

There are about 12 ways to install `Neovim`, and they all install different versions or require differnt things. It's confusing. I think I have done it by `AppImage` before, and possibly by the `ppk` thing, but now I think the easiest is just to download the `.tar` file, extract, and link. 

Note: The `sudo apt get neovim` or similar, installs a VERY out of date Neovim.

Current setup works with the 0.9.x version from

https://github.com/neovim/neovim/releases

It can be downloaded with
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
 
Also install a C compiler for some reason (opening files will give a warning otherwise)
```
sudo apt install gcc
```

I don't know that `gcc` is the best choice, there are others, but this works. 


## Installing docker

Possible that docker is not available in the default package repositories, so a few extra steps need to be done so that it can be found. 

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
And now docker should be able to be installed like normal

```
sudo apt update
sudo apt install docker-ce
```

Then, to allow running docker without `sudo`
```
sudo usermod -aG docker $USER
```


## Set up backups
Follow instructions in `~/backup-scripts/README.md`

Note: this is one of the folders that a link is created for from the dotfiles repo. 


