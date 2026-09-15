# Aliases and functions (from aliases.zsh)
alias vim="nvim"
alias vi="nvim"

alias add_alias="vim ~/.oh-my-zsh/custom/extra.zsh"
alias cd_nvim="cd ~/.config/nvim/lua/custom/"

export PYENV_ROOT="$HOME/.pyenv"

# List of directories to check
directories=(
    "$HOME/.local/bin"
    "/snap/bin"
    "/opt/nvim/"
    "$PYENV_ROOT/bin"
)

# Loop through each directory and add to PATH if it exists
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        export PATH="$dir:$PATH"
    fi
done

# Init pyenv if available
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Completions for task if available
if command -v task >/dev/null 2>&1; then
    eval "$(task --completion zsh)"
fi

# Cursor appimage
function cursor {
        ~/appimages/Cursor-0.49.6-x86_64.AppImage --no-sandbox $@
}

# ssh: force a universally-available TERM for outbound connections.
# tmux sets TERM=tmux-256color (good local rendering), but ssh forwards $TERM
# to the remote, and many minimal/older hosts (Debian/Proxmox without
# ncurses-term) lack that terminfo entry -- which breaks readline line editing
# (backspace moves the cursor the wrong way, no visual delete). xterm-256color
# is present on essentially every host, so downgrade just for ssh. `command`
# avoids recursing into this function. Local panes keep tmux-256color.
ssh() { TERM=xterm-256color command ssh "$@"; }

# --- Agent aliases: one-word launchers per model tier ----------------------
# Shorthand for spinning up a standard Claude Code session pinned to a given
# model with permission prompts off for delegated / hands-off agent runs.
# Note: `--model=opus` is plain Opus (200K), whereas the settings.json default
# is "opus[1m]" -- use `--model='opus[1m]'` here instead if you want the alias
# to keep the 1M-token context window. Same applies to sonnet. Fable is
# 1M-context by default, so no suffix needed there.
alias fable="claude --dangerously-skip-permissions --model=fable"
alias opus="claude --dangerously-skip-permissions --model=opus"
alias sonnet="claude --dangerously-skip-permissions --model=sonnet"
alias haiku="claude --dangerously-skip-permissions --model=haiku"

# obs — open a file in Obsidian (rich, mermaid-rendering view). The reliable
# way to reach Obsidian regardless of terminal click-modifier quirks; the
# Alacritty Option+Shift+click hint is the convenience path, this is the
# guarantee. Resolves relative paths against $PWD so it works from inside a repo
# (e.g. `obs README.md`). Only works for files inside an Obsidian vault
# (~/github, ~/ObsidianNotes/General, ~/.claude, …).
obs() {
  local f="${1:?usage: obs <file.md>}"
  [ -e "$f" ] || { echo "obs: no such file: $f" >&2; return 1; }
  ~/dotfiles/bin/open-in-obsidian "$(cd "$(dirname "$f")" && pwd)/$(basename "$f")"
}
