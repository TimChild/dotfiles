# macOS Brewfile — see docs/macos-setup.md. Install with: brew bundle --file=~/dotfiles/Brewfile
tap "copper-browser/copper"

# --- core CLI (from dotfiles: macos + dev_tools + terminal roles) ---
brew "git"
brew "git-lfs"
brew "gh"
brew "gnupg"
brew "pinentry-mac"
brew "neovim"
brew "tmux"
brew "lazygit"
brew "go-task"
brew "direnv"
brew "uv"
brew "awscli"
brew "ripgrep"
brew "fd"
brew "fzf"
brew "jq"
brew "wget"

# --- wizard stack toolchains ---
brew "node"      # phi needs >=22.19, p3code wants Node 26
brew "pnpm"      # p3code
brew "go"        # feads
brew "icu4c"     # feads (Dolt regex dependency)
brew "vite-plus" # p3code (vp)
brew "rustup"    # p3code desktop build (+ general Rust)

# --- apps ---
cask "copper-browser/copper/copper"
cask "1password"
cask "1password-cli"
cask "google-chrome"
cask "obsidian"
cask "ghostty"    # alacritty cask disabled by Homebrew (not notarized)
cask "font-jetbrains-mono-nerd-font"
cask "rectangle"   # window snapping
cask "stats"       # menu-bar CPU/RAM/net/disk

# --- networking / VPN ---
cask "tailscale-app"
cask "surfshark"
cask "openvpn-connect"
cask "claude-code"
