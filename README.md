# Dotfiles for Ubuntu 22.04

Repository containing useful scripts and configuration files for Ubuntu.

Works by creating symlinks from the `~/` directory to the files in this repository so that they always stay in sync and can be backed up or restored via git.


## Setup

Clone this repository to `~/dotfiles`

Make sure the files in the `~/dotfiles/scripts` directory are executable

```bash
chmod +x ~/dotfiles/scripts/*
```

Run the script to setup the symlinks
    
```bash
~/dotfiles/scripts/setup-symlinks.sh
```

