# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# Ensure backup scripts have run recently
CURRENT_TIME=$(date +%s)

# Daily backup
if [[ -f ~/dotfiles/.last_daily_backup ]]; then
  LAST_MODIFIED=$(date -d "$(cat ~/dotfiles/.last_daily_backup)" +%s)
  ONE_DAY=$((24 * 60 * 60))  # 24 hours in seconds

  if [[ $(($CURRENT_TIME - $LAST_MODIFIED)) -gt $ONE_DAY ]]; then
      echo "INFO: Detected last daily backup older than one day, running ~/backup-scripts/daily-backup.sh now"
      # Run your daily backup script
      ~/backup-scripts/daily-backup.sh
  fi
else
  echo "WARNING: ~/dotfiles/.last_daily_backup does not exist. Make sure you set up scheduled backups with crontab. See instructions in ~/backup-scripts/readme.md"
fi
# Weekly backup
if [[ -f ~/dotfiles/.last_weekly_backup ]]; then
  LAST_MODIFIED=$(date -d "$(cat ~/dotfiles/.last_weekly_backup)" +%s)
  ONE_WEEK=$((24 * 60 * 60 * 7))  # 7 days in seconds

  if [[ $(($CURRENT_TIME - $LAST_MODIFIED)) -gt $ONE_WEEK ]]; then
      echo "INFO: Detected last weekly backup older than one week, running ~/backup-scripts/weekly-backup.sh now"
      # Run your daily backup script
      ~/backup-scripts/weekly-backup.sh
  fi
else
  if [[ -f ~/dotfiles/.last_daily_backup ]]; then
    echo "WARNING: No previous weekly backup, but daily backup found. Running ~/backup-scripts/weekly-backup.sh now"
    ~/backup-scripts/weekly-backup.sh
  else
    echo "WARNING: No weekly or daily backup found. Make sure you set up scheduled backups with crontab. See instructions in ~/backup-scripts/readme.md"
  fi
fi

# Created by `pipx` on 2023-11-03 18:27:27
export PATH="$PATH:/home/tim/.local/bin"

# 2023-11-03 -- Enable autocompletion for pipx
eval "$(register-python-argcomplete3 pipx)"
