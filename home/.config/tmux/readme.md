# Installation instructions

Also several ways to install, but I think it matters less with `tmux` as it is not changing as quickly. 

Here is the link to the installation instructions

https://github.com/tmux/tmux/wiki/Installing#appimage-package

I think I just went for the `sudo apt update && sudo apt get tmux` option. I don't 100% remember.

# General Setup

Did initial setup following this video

https://www.youtube.com/watch?v=DzNmUNvnB04&t


# Additional Plugins / Config notes

I think just the `tmux.conf` file in `.config/tmux` is enough to set up tmux. 

Note: using `tmux-continuum` autosaves the sessions every 5 minutes or so, and will auto reload the last saved state on resuming tmux. This is particularly useful for my WSL2 ubuntu that I shutdown tomake backups of.


# Versions

Sept 2023:

```
apt list | grep tmux

python3-libtmux/jammy 0.10.1-1 all
python3-tmuxp/jammy 1.9.2-1 all
tmux-plugin-manager/jammy 3.0.0-1.1 all
tmux-themepack-jimeh/jammy 0+git20190430-1b1b809-1 all
tmux/jammy-updates,jammy-security,now 3.2a-4ubuntu0.2 amd64 [installed,automatic]
tmuxinator/jammy 3.0.1-1 all
tmuxp/jammy 1.9.2-1 all

```

