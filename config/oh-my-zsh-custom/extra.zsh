source ~/dotfiles/task-completions.zsh

# export BUN_INSTALL="$HOME/.local/share/reflex/bun"
export PYENV_ROOT="$HOME/.pyenv"

# List of directories to check
directories=(
    "$HOME/.local/bin"
    "/snap/bin"
    "/opt/nvim/"
    # "$BUN_INSTALL"
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

# # Daily backup
# if [[ -f ~/dotfiles/.last_daily_backup ]]; then
#   LAST_MODIFIED=$(date -d "$(cat ~/dotfiles/.last_daily_backup)" +%s)
#   ONE_DAY=$((24 * 60 * 60))  # 24 hours in seconds
#
#   if [[ $(($CURRENT_TIME - $LAST_MODIFIED)) -gt $ONE_DAY ]]; then
#       echo "INFO: Detected last daily backup older than one day, running ~/backup-scripts/daily-backup.sh now"
#       # Run your daily backup script
#       ~/backup-scripts/daily-backup.sh
#   fi
# else
#   echo "WARNING: ~/dotfiles/.last_daily_backup does not exist. Make sure you set up scheduled backups with crontab. See instructions in ~/backup-scripts/readme.md"
# fi
# # Weekly backup
# if [[ -f ~/dotfiles/.last_weekly_backup ]]; then
#   LAST_MODIFIED=$(date -d "$(cat ~/dotfiles/.last_weekly_backup)" +%s)
#   ONE_WEEK=$((24 * 60 * 60 * 7))  # 7 days in seconds
#
#   if [[ $(($CURRENT_TIME - $LAST_MODIFIED)) -gt $ONE_WEEK ]]; then
#       echo "INFO: Detected last weekly backup older than one week, running ~/backup-scripts/weekly-backup.sh now"
#       # Run your daily backup script
#       ~/backup-scripts/weekly-backup.sh
#   fi
# else
#   if [[ -f ~/dotfiles/.last_daily_backup ]]; then
#     echo "WARNING: No previous weekly backup, but daily backup found. Running ~/backup-scripts/weekly-backup.sh now"
#     ~/backup-scripts/weekly-backup.sh
#   else
#     echo "WARNING: No weekly or daily backup found. Make sure you set up scheduled backups with crontab. See instructions in ~/backup-scripts/readme.md"
#   fi
# fi

