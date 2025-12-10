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
    else
      echo "WARNING: Did not find \"$dir\" to add to path"
    fi
done

# Init pyenv
eval "$(pyenv init -)"

# Completions for task
eval "$(task completion --shell zsh)"

# Cursor appimage
function cursor {
        ~/appimages/Cursor-0.49.6-x86_64.AppImage --no-sandbox $@
}
