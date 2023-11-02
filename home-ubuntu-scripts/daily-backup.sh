#!/bin/bash

# Where to backup to
BACKUP_DIR="/mnt/g/11Backups/wsl2_ubuntu/daily/"

# What to backup
PROJECTS_DIR="$HOME/projects"

# Backup projects directory
rsync -av --delete $PROJECTS_DIR/ $BACKUP_DIR/projects/
