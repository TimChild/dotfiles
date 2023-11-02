# Installing Neovim instructions

There are many different ways to install Neovim on ubuntu, and they are not at all equal. It is very easy to end up with a very out of date version.

For example, when installing this time (~Sept 2023), `apt-get` was installing `0.6.x` from over a year ago, but the up-to-date version was `0.9.x`.

Here is a link to official Neovim instructions

https://github.com/neovim/neovim/wiki/Installing-Neovim

In the end, I went with the download, extract, make shortcut to the executable.

1. Download and extract to `/opt/nvim`
2. Create `ln -s /opt/nvim-linux64/bin/nvim /usr/local/bin/`
3. Possibly have to make executable with `chmod a+x /opt/nvim-linux64/bin/nvim`
4. Set alias in `.bash_aliases` for `alias vim='nvim'`

Note: it's possible that I also have an older version of Neovim installed by `apt`. Use `nvim -v` to check the version that is actually being used.


# General Setup

Did initial setup following this video

https://www.youtube.com/watch?v=DzNmUNvnB04&t


# Plugins / Config notes

Building around NvChad. Not done much customizing beyond the video above

## Clipboard with WSL2

By default, the opening of `nvim` is slowed down by ~1s due to something related to the clipboard in WSL2. See the instructions below for how to fix.

https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl

Basically, in the `.../custom/init.lua` file, add:

```
    let g:clipboard = {
                \   'name': 'WslClipboard',
                \   'copy': {
                \      '+': 'clip.exe',
                \      '*': 'clip.exe',
                \    },
                \   'paste': {
                \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \   },
                \   'cache_enabled': 0,
                \ }
```


# Versions

Sept 2023

```
nvim -v

NVIM v0.9.2
Build type: Release
LuaJIT 2.1.1692716794
```
