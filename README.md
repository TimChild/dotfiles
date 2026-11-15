# Dotfiles setup

**macOS:** follow [docs/macos-setup.md](docs/macos-setup.md) (Homebrew + `Brewfile`, Ghostty, 1Password SSH signing, wizard stack). The steps below are for Linux.

Setup by running the following commands:
```sh
sudo apt update && sudo apt install git
```

or 

```sh
sudo pacman -Sy git
```

then

```sh
git clone https://github.com/TimChild/dotfiles.git
~/.dotfiles/bin/dotfiles
```
