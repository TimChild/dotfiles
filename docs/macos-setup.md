# New Mac setup (macOS)

The runbook from setting up a fresh home Mac (macOS 27, Apple Silicon, November 2026).
The Linux path is still `bin/dotfiles` + Ansible. On a Mac, follow these steps instead.
Steps marked **(you)** need a password, Touch ID, or a browser sign-in, so an agent can't do them.

## 1. Homebrew and the Brewfile

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"   # (you): sudo password; also installs the Xcode Command Line Tools
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Before Homebrew is installed, don't run `python3` or `git`. They are stubs that only pop up the Command Line Tools installer.

Install everything. You need the dotfiles first: either `git clone https://github.com/TimChild/dotfiles ~/dotfiles`, or copy the [`Brewfile`](../Brewfile) across:

```bash
brew bundle --file=~/dotfiles/Brewfile      # (you): the tailscale-app and openvpn-connect .pkg installers ask for sudo
```

Notes:

- **Alacritty:** Homebrew disabled the cask on 2026-09-01 because the app isn't notarized. Ghostty replaces it. [`config/ghostty/config`](../config/ghostty/config) matches the Alacritty setup: JetBrainsMono Nerd Font, Catppuccin Mocha, and it opens straight into `tmux new-session -A -s 0`.
- **Copper tap:** Homebrew reports the `copper-browser/copper` tap as untrusted, but the cask still installs. Copper updates itself afterwards.

## 2. GitHub

```bash
gh auth login --hostname github.com --git-protocol https --web --scopes "read:org,repo,workflow"   # (you): device code in the browser
gh auth setup-git
```

Run this in your own terminal. A terminal tab opened by an agent may not accept typing at the interactive prompt. In that case, run it with `</dev/null` and the device code prints instead.

## 3. Repos

```bash
~/dotfiles/bin/macos-clone-repos
```

The layout matches the work Mac, so per-project Claude memory (keyed by path) lines up:

- `~/github/{phi,p3code,feads,phi-remote}`: the wizard stack
- `~/github/copper-browser/Copper`: Copper source
- `~/github/exowatt-oss/*` and `~/github/couplet-physical-ai/*`: the open-source orgs
- `~/github/personal/*`: PaperTrade (zebutrader), adventuresoftim, homelab (Home Assistant is in `homeassistant/`), claude-config, phi-personal, tim-claude-marketplace

## 4. Shell, tmux, nvim

```bash
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
D=~/dotfiles
ln -sfn $D/home/.zshrc.macos ~/.zshrc
for f in plugins.zsh extra.zsh uv-autocomplete.zsh; do ln -sfn $D/config/oh-my-zsh-custom/$f ~/.oh-my-zsh/custom/$f; done
mkdir -p ~/.config/tmux ~/.config/ghostty
ln -sfn $D/config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sfn $D/config/nvim ~/.config/nvim
ln -sfn $D/config/ghostty/config ~/.config/ghostty/config
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
TMUX_PLUGIN_MANAGER_PATH=~/.config/tmux/plugins tmux -L setup -f ~/.config/tmux/tmux.conf new-session -d 'sleep 30' \
  && ~/.config/tmux/plugins/tpm/bin/install_plugins; tmux -L setup kill-server
```

[`home/.zshrc.macos`](../home/.zshrc.macos) is the Mac `.zshrc`. On Linux, the Ansible role generates `.zshrc` instead, and `home/.zshrc` is a stale Linux copy. zinit installs its plugins on the first interactive shell.

## 5. 1Password, SSH and git signing

1. **(you)** Sign in to 1Password. Under Settings › Developer, turn on **Integrate with 1Password CLI** and **Use the SSH agent**. Then add the extension in Chrome and in Copper (Settings › Extensions; paste the extension's Chrome Web Store link).
2. Create an SSH key in 1Password. It's used for both git signing and server access:

   ```bash
   op item create --category "SSH Key" --vault Private --title "<machine> SSH key" --ssh-generate-key ed25519
   ```

3. Keep the shared `home/.ssh/config` untouched and put the agent line in a small local file:

   ```sshconfig
   # ~/.ssh/config (local file, not a symlink)
   Include ~/dotfiles/home/.ssh/config

   Host *
     IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
   ```

   If 1Password offers to edit `~/.ssh/config` for you, say no. While that file is a symlink, its edit lands in the shared dotfiles copy.

4. Sign with that SSH key instead of the old GPG key (`5CFD63FA…`, which exists only on the work Mac):

   ```gitconfig
   # ~/.gitconfig (local file)
   [include]
       path = ~/dotfiles/home/.gitconfig
   [user]
       signingkey = ssh-ed25519 AAAA…        # the public key
   [gpg]
       format = ssh
   [gpg "ssh"]
       program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
       allowedSignersFile = ~/.ssh/allowed_signers   # "<email> ssh-ed25519 AAAA…"
   [tag]
       gpgSign = true
   ```

5. Register the key on GitHub so signed tags show as Verified. This needs one extra gh permission: `gh auth refresh -s admin:ssh_signing_key`, then `gh ssh-key add <pub> --type signing`.

## 6. Wizard stack

```bash
cd ~/github/phi && npm ci --ignore-scripts && npm run build:offline
cd ~/github/feads && ICU=$(brew --prefix icu4c) CGO_CPPFLAGS="-I$ICU/include" CGO_CXXFLAGS="-I$ICU/include" \
  CGO_LDFLAGS="-L$ICU/lib" PKG_CONFIG_PATH="$ICU/lib/pkgconfig" go build -o ./bin/bd ./cmd/bd
cd ~/github/p3code && vp i && vp run build
mkdir -p ~/.local/bin && ln -sfn ~/github/feads/bin/bd ~/.local/bin/bd
printf '#!/bin/sh\nexec /opt/homebrew/bin/node "$HOME/github/phi/packages/coding-agent/dist/bundle/cli.js" "$@"\n' > ~/.local/bin/phi && chmod +x ~/.local/bin/phi
```

Notes:

- **Absolute paths in the `phi` wrapper:** keep them. Apps opened from the Dock or Spotlight don't get the shell's PATH, and P3 launches `phi --mode rpc`.
- **P3 Code.app:** to build the Mac app, run `rustup default stable && rustup target add aarch64-apple-darwin` first, then `node scripts/build-desktop-artifact.ts --platform mac --target dmg --arch arm64`. Copy `release/P3-Code-*.dmg`'s app into /Applications. The build is ad-hoc signed and opens without a Gatekeeper prompt.
- **phi-remote:** needs full Xcode from the App Store. Then run `npm ci && npx expo run:ios`.

## 7. Claude Code and phi config (home)

- **Personal parts only from `claude-config`:** copy `CLAUDE.md`, `skills/` (except `.trash`/`synced`), `projects/*/memory` and `agent-memory/` into `~/.claude`.
  - Write a home `settings.json`: bypass permissions, `effortLevel: high`, vim editor mode, and the `tim-personal` marketplace pointed at `~/github/personal/tim-claude-marketplace`.
  - Leave out the Exowatt OTEL telemetry, the Exowatt marketplaces, the feads SessionStart hook and the Orca hooks.
- **phi-personal:** rsync `AGENTS.md`, `skills/`, `prompts/`, `scripts/` and `extensions/phi-selfmanage` into `~/.pi/agent`. Skip `phi-otel` and the `orca-*` extensions.
- **Secrets:** put `op://` references in `~/.pi/agent/phi.env.op`, for example `TYPESAFE_API_KEY=op://Private/<item-id>/credential`.
  - Run `~/.pi/agent/phi-env-gen.sh`: it's `phi-first-run-setup/phi-env-gen.sh` with the extra variable added to its allowlist. It writes a chmod-600 `phi.env`.
  - `~/.zprofile` sources `phi.env` for every login shell.
- **Claude Code CLI:** run `claude auth login` **(you)**.

## 8. Copper

- **(you)** Turn on Settings › Agents › *Let agents drive this window*. Then `copper setup status` should say `ready` for phi, claude and cli. `copper setup claude|phi` registers the MCP server and the `/jev` command, and symlinks the `copper-cli` skill from the Copper repo.
- **Jev vision:** Settings › Agents › Jev mode › *What Jev sees* is `auto` by default, which sends images only when the element table is ambiguous. Copper sends TypeSafe's `TypeSafe-Danger-Zone-Images` header itself.
- **Copper Cloud:** self-hosted on the homelab (see the homelab repo's copper-cloud docs). Link a new Mac with a pairing code from a Mac that's already signed in: Settings › Cloud › *Pair another Mac*.

## 9. Everything else

- **Apps from the Brewfile:**
  - Rectangle: window snapping
  - Stats: CPU, RAM, network and disk in the menu bar
  - VPNs: Tailscale, Surfshark, OpenVPN Connect
  - Obsidian
- **(you)** Open each one once to grant its permissions: Accessibility for Rectangle, the VPN configurations, sign-ins.
- **Check:** `fdesetup status` should say FileVault is on. Set up Time Machine.
