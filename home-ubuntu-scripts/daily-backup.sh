#!/bin/bash

# Where to backup to
BACKUP_DIR="/mnt/g/11Backups/wsl2_ubuntu/daily/"

declare -A ITEMS_TO_BACKUP
ITEMS_TO_BACKUP[PROJECTS_DIR]="$HOME/projects"
ITEMS_TO_BACKUP[CONFIG_DIR]="$HOME/.config"
ITEMS_TO_BACKUP[SPECIFIC_FILE]="$HOME/path_to_specific_file.txt"
# Add more directories or files as needed

for ITEM in "${!ITEMS_TO_BACKUP[@]}"; do
    if [ -d "${ITEMS_TO_BACKUP[$ITEM]}" ]; then
        # Item is a directory
        rsync -av --delete "${ITEMS_TO_BACKUP[$ITEM]}/" "$BACKUP_DIR/$ITEM/"
    else
        # Item is a file
        rsync -av "${ITEMS_TO_BACKUP[$ITEM]}" "$BACKUP_DIR/$ITEM"
    fi
done
