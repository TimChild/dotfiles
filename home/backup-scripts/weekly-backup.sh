#!/bin/bash

# Directory where this script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# File to save the package list
PACKAGE_LIST="$DOTFILES_DIR/package_list.txt"

# Weekly backup location
WEEKLY_BACKUP_DIR="/mnt/g/11Backups/wsl2_ubuntu/package_list/$(date '+%Y-%m-%d')"

# Create the directory if it doesn't exist
mkdir -p $WEEKLY_BACKUP_DIR

# Copy the package list
cp $PACKAGE_LIST "$WEEKLY_BACKUP_DIR/package_list.txt"
