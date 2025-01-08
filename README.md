# Dotfiles (primarily for linux use)

Setup by running the following commands:
```sh
sudo apt update && sudo apt install gh -y
gh auth login
gh repo clone TimChild/dotfiles
source ~/dotfiles/scripts/setup_terminal.sh
```

Additional setup steps will be shown in terminal. 


TODO: Better describe the full setup process, and remove old README, and old wsl2_install_instructions

---

# OLD README

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

## Backup scripts

Backup scripts are automatically linked in `~/backup_scripts`, but they are not automatically added to `crontab`. Follow the instructions in `~/backup-scripts/README.md`. 

Note: The `.profile` does look for backups, and will give warnings if automatic backups are not set up or have not yet run. 

## Clean install

For a full installation, see the `wsl2_install_instructions.md`.


## Troubleshooting

Long startup time of wsl2:
- Run `dmesg` after startup to see how long everything took. The line where the number has increased a lot shows where time was spent. 
- Something to do with `hv_balloon` was possibly fixed by just doing a `sudo apt update && sudo apt upgrade` or maybe `sudo apt dist-upgrade`. (takes < 0.01 s when working properly)
- Something to do with `ldconfig` was related to mapped network drives being inaccessible. Don't know of any other fix than to just make sure the network drives are accessible. (takes ~0.3 s when things are working right)
