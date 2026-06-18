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

# --- Claude Code via AWS Bedrock (opt-in launcher) -------------------------
# Run `claude-bedrock` to drive Claude Code against AWS Bedrock (Exowatt-Dev
# account 340752802981) on Opus 4.8, instead of the first-party Anthropic API.
# Plain `claude` is UNCHANGED -- it still uses ~/.claude/settings.json
# ("model": "opus[1m]") on the first-party API. So this is a no-risk A/B: type
# `claude-bedrock` for Bedrock, `claude` for first-party. Nothing global is
# mutated; revert = stop using the function.
#   - Profile exowatt-dev (NOT enterprise-dev, which lacks Opus 4.7/4.8 access).
#   - global.* inference profiles: higher pooled TPM; Fable 5 is global-only.
#   - Auto-runs `aws sso login` if the SSO token has expired.
# Verified 2026-06-16: opus-4-8 invokes end-to-end via Claude Code; a 700K-token
# context was accepted with the context-1m beta on this account/region.
claude-bedrock() {
  if ! aws sts get-caller-identity --profile exowatt-dev >/dev/null 2>&1; then
    echo "claude-bedrock: AWS SSO token expired -- running 'aws sso login --profile exowatt-dev'..." >&2
    aws sso login --profile exowatt-dev || { echo "claude-bedrock: SSO login failed; aborting." >&2; return 1; }
  fi
  # Default to the Opus tier unless the caller passed their own --model.
  local model_args=()
  if [[ " $* " != *" --model "* ]]; then
    model_args=(--model opus)
  fi
  # The [1m] suffix on the Opus model enables the 1M-token context window on
  # Bedrock (Opus 4.6+ / Sonnet 4.6 support it). Claude Code strips the suffix
  # before calling Bedrock and adds the context-1m beta transparently -- this
  # mirrors the first-party "opus[1m]" you run today. Verified: a 700K-token
  # context was accepted on this account/region.
  CLAUDE_CODE_USE_BEDROCK=1 \
  AWS_REGION=us-east-1 \
  AWS_PROFILE=exowatt-dev \
  ANTHROPIC_DEFAULT_OPUS_MODEL='global.anthropic.claude-opus-4-8[1m]' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='global.anthropic.claude-sonnet-4-6' \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='global.anthropic.claude-haiku-4-5-20251001-v1:0' \
    command claude "${model_args[@]}" "$@"
}

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
