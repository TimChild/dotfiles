#!/bin/bash

echo "$(date '+%Y-%m-%d %H:%M:%S')" > ~/dotfiles/.last_daily_backup

# Directory where this script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dotfiles directory (repository)
DOTFILES_DIR="$HOME/dotfiles"
LOGFILE="$DOTFILES_DIR/backup_log.txt"
echo "Daily Backup - $(date)" >> $LOGFILE

# File to save the package list
PACKAGE_LIST="$DOTFILES_DIR/package_list.txt"

# Get the package list
dpkg --get-selections > $PACKAGE_LIST

if [ $? -eq 0 ]; then
    echo "Package list saved successfully." >> $LOGFILE
else
    echo "Error encountered while saving package list." >> $LOGFILE
fi

# Change to dotfiles directory
cd $DOTFILES_DIR

# Check for changes and commit if any exist (ssh must be set up so user/pass not required)
if [[ $(git status -s) ]]; then
    git add .
    #git commit -m "$(date '+%Y-%m-%d') - automatic daily backup"
    #git push origin main

    if [ $? -eq 0 ]; then
        echo "Pushed changes to dotfile repo successfully" >> $LOGFILE
    else
        echo "Error encountered while pushing changes." >> $LOGFILE
    fi
fi

