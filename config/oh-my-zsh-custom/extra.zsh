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
# account 340752802981) on Opus 4.8 by default (or Fable 5 via `--model fable`),
# instead of the first-party Anthropic API.
# Plain `claude` is UNCHANGED -- it still uses ~/.claude/settings.json
# ("model": "opus[1m]") on the first-party API. So this is a no-risk A/B: type
# `claude-bedrock` for Bedrock, `claude` for first-party. Nothing global is
# mutated; revert = stop using the function.
#   - Profile exowatt-dev (NOT enterprise-dev, which lacks Opus 4.7/4.8 access).
#   - global.* inference profiles: higher pooled TPM (Opus/Sonnet/Haiku).
#   - `--model fable` selects Fable 5 via the us.* profile, NOT global.*: as of
#     2026-07-01 global.anthropic.claude-fable-5 throws InternalServerException
#     (500) on this account -- Bedrock hasn't provisioned Fable across every
#     region the global profile routes to yet. us.anthropic.claude-fable-5
#     works. Revisit global.* once AWS finishes the Fable rollout. Fable is
#     1M-context by default, so -std does NOT shrink it (the 200K cap = Opus).
#   - Auto-runs `aws sso login` if the SSO token has expired.
# Verified 2026-06-16: opus-4-8 invokes end-to-end via Claude Code; a 700K-token
# context was accepted with the context-1m beta on this account/region.
#
# OTLP telemetry note: the OTEL env block in ~/.claude/settings.json applies on
# every launch (this launcher only prepends Bedrock vars), so metrics DO export.
# But on Bedrock there's no Anthropic OAuth login, so Claude Code can't derive
# user.email -- usage lands in the anonymous bucket on the dashboards. We set it
# explicitly here so Bedrock sessions attribute to the same identity as
# first-party. user.id matches the first-party telemetry hash so panels keyed on
# either label unify. Verify after a session: query Prometheus user_email.
_CLAUDE_BEDROCK_OTEL_ATTRS='user.email=tchild@exowatt.com,user.id=11120af17c1d64cf1b289173c92a6c3fd96620a0b1f89bcd540df96555eed4bb'
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
  OTEL_RESOURCE_ATTRIBUTES="$_CLAUDE_BEDROCK_OTEL_ATTRS" \
  ANTHROPIC_DEFAULT_FABLE_MODEL='us.anthropic.claude-fable-5' \
  ANTHROPIC_DEFAULT_OPUS_MODEL='global.anthropic.claude-opus-4-8[1m]' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='global.anthropic.claude-sonnet-4-6' \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='global.anthropic.claude-haiku-4-5-20251001-v1:0' \
    command claude "${model_args[@]}" "$@"
}

# Same as claude-bedrock but without the 1M context window (standard 200K).
# Use this when you're getting 503s on Opus -- the 1M tier has much lower
# provisioned capacity on Bedrock and 503s even on the first message.
claude-bedrock-std() {
  if ! aws sts get-caller-identity --profile exowatt-dev >/dev/null 2>&1; then
    echo "claude-bedrock-std: AWS SSO token expired -- running 'aws sso login --profile exowatt-dev'..." >&2
    aws sso login --profile exowatt-dev || { echo "claude-bedrock-std: SSO login failed; aborting." >&2; return 1; }
  fi
  local model_args=()
  if [[ " $* " != *" --model "* ]]; then
    model_args=(--model opus)
  fi
  CLAUDE_CODE_USE_BEDROCK=1 \
  AWS_REGION=us-east-1 \
  AWS_PROFILE=exowatt-dev \
  OTEL_RESOURCE_ATTRIBUTES="$_CLAUDE_BEDROCK_OTEL_ATTRS" \
  ANTHROPIC_DEFAULT_FABLE_MODEL='us.anthropic.claude-fable-5' \
  ANTHROPIC_DEFAULT_OPUS_MODEL='global.anthropic.claude-opus-4-8' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='global.anthropic.claude-sonnet-4-6' \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='global.anthropic.claude-haiku-4-5-20251001-v1:0' \
    command claude "${model_args[@]}" "$@"
}

# --- Claude Code via the Claude apps gateway (opt-in launcher) --------------
# Run `claude-gateway` to drive Claude Code through the self-hosted Claude apps
# gateway (https://claude-gateway.dev.exowatt.com on VM 108 -> Bedrock).
# Sign-in is Google Workspace SSO (device flow), NOT AWS SSO -- no aws profile
# needed; per-user attribution + spend caps happen server-side at the gateway.
# Plain `claude` and `claude-bedrock` are UNCHANGED -- three-way A/B:
#   claude          first-party Anthropic API (Enterprise seat)
#   claude-bedrock  direct Bedrock (env-var path, AWS SSO, client-side creds)
#   claude-gateway  gateway -> Bedrock (SSO identity, server-side creds, caps)
# Isolation: CLAUDE_CONFIG_DIR keeps auth/session state in ~/.claude-gateway/,
# so the gateway login can NEVER clobber the first-party OAuth in ~/.claude.
# This replaces the managed-settings.json /Library path for the pilot A/B --
# that file is machine-wide and would force EVERY claude launch onto the
# gateway. OTEL attrs not set: the gateway stamps identity server-side.
#
# Config SHARING (so the A/B compares like-for-like): the launcher symlinks the
# shareable pieces of ~/.claude into ~/.claude-gateway (skills, plugins,
# CLAUDE.md, projects [= auto-memory + transcripts], agent-memory, plans, .env)
# and regenerates settings.json ON EVERY LAUNCH as (~/.claude/settings.json +
# the two gateway login keys), so main-config changes propagate automatically.
# Deliberately NOT shared: .claude.json (OAuth account/session state -- sharing
# it would defeat the auth isolation) => user-scope `claude mcp add` servers
# don't carry over; re-add them once under claude-gateway.
# First connect prompts to trust the TLS leaf fingerprint -- verify against
# the one published in #it-support (cert renews ~60-90d; re-verify then).
claude-gateway() {
  local gw="$HOME/.claude-gateway" main="$HOME/.claude"
  mkdir -p "$gw"
  # Shareable config: symlink (idempotent; skip anything that became a real
  # file/dir locally so we never clobber gateway-local state).
  local item
  for item in CLAUDE.md skills plugins projects agent-memory plans .env; do
    if [[ -e "$main/$item" && ! -e "$gw/$item" ]]; then
      ln -s "$main/$item" "$gw/$item"
    fi
  done
  # settings.json = main settings + gateway login overlay (regenerated every
  # launch so it tracks ~/.claude/settings.json; never symlinked).
  # Hardening (2026-07-01 incident): a session "on the gateway" was silently
  # running DIRECT Bedrock — CLAUDE_CODE_USE_BEDROCK=1 + AWS_*/ANTHROPIC_*
  # model overrides landed in the profile's settings.json env, which bypasses
  # gateway login entirely (no allowlist, no caps, no attribution). Strip
  # those keys on every launch; preserve in-session prefs (theme/model).
  python3 - "$main/settings.json" "$gw/settings.json" <<'PYEOF'
import json, sys
base = {}
try:
    base = json.load(open(sys.argv[1]))
except Exception:
    pass
prev = {}
try:
    prev = json.load(open(sys.argv[2]))
except Exception:
    pass
for k in ("theme", "model"):
    if k in prev:
        base[k] = prev[k]
env = dict(base.get("env", {}))
for k in list(env):
    if k == "CLAUDE_CODE_USE_BEDROCK" or k.startswith(("AWS_", "ANTHROPIC_DEFAULT_", "ANTHROPIC_MODEL", "ANTHROPIC_BEDROCK")):
        env.pop(k)
base["env"] = env
base["forceLoginMethod"] = "gateway"
base["forceLoginGatewayUrl"] = "https://claude-gateway.dev.exowatt.com"
json.dump(base, open(sys.argv[2], "w"), indent=2)
PYEOF
  # Scrub direct-provider env vars from the LAUNCH environment too (not just
  # the profile settings): CLAUDE_CODE_USE_BEDROCK=1 in the inherited shell
  # env (e.g. a tmux pane whose server inherited it, or a shell inside a
  # claude-bedrock session) silently bypasses gateway login — the env var IS
  # the auth, so no Google prompt ever appears. env -u guarantees a clean
  # start regardless of shell contamination.
  env -u CLAUDE_CODE_USE_BEDROCK -u CLAUDE_CODE_USE_VERTEX \
      -u AWS_PROFILE -u AWS_REGION -u AWS_ACCESS_KEY_ID -u AWS_SECRET_ACCESS_KEY \
      -u ANTHROPIC_MODEL -u ANTHROPIC_DEFAULT_FABLE_MODEL \
      -u ANTHROPIC_DEFAULT_OPUS_MODEL -u ANTHROPIC_DEFAULT_SONNET_MODEL \
      -u ANTHROPIC_DEFAULT_HAIKU_MODEL -u OTEL_RESOURCE_ATTRIBUTES \
      CLAUDE_CONFIG_DIR="$gw" claude "$@"
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
