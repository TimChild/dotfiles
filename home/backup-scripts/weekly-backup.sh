#!/bin/bash
#
LOGFILE="$DOTFILES_DIR/backup_log.txt"
echo "Weekly Backup - $(date)" >> $LOGFILE
echo "$(date '+%Y-%m-%d %H:%M:%S')" > ~/dotfiles/.last_weekly_backup

# Directory where this script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# File to save the package list
PACKAGE_LIST="$DOTFILES_DIR/package_list.txt"

# Weekly backup location
WEEKLY_BACKUP_DIR="/mnt/g/11Backups/wsl2_ubuntu/$(date '+%Y-%m-%d')"

# Create the directory if it doesn't exist
mkdir -p $WEEKLY_BACKUP_DIR

# Copy the package list
cp $PACKAGE_LIST "$WEEKLY_BACKUP_DIR/package_list.txt"
cp $LOGFILE "$WEEKLY_BACKUP_DIR/backup_log.txt"

if [ $? -eq 0 ]; then
    echo "Weekly Backup successful." >> $LOGFILE
else
    echo "Error encountered during weekly backup." >> $LOGFILE
fi
