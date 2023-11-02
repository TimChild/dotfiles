#!/bin/bash

# Directory where this script resides
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dotfiles directory (repository)
DOTFILES_DIR="$HOME/dotfiles"

# File to save the package list
PACKAGE_LIST="$DOTFILES_DIR/package_list.txt"

# Get the package list
dpkg --get-selections > $PACKAGE_LIST

# Change to dotfiles directory
cd $DOTFILES_DIR

# Check for changes and commit if any exist (ssh must be set up so user/pass not required)
if [[ $(git status -s) ]]; then
    git add .
    git commit -m "$(date '+%Y-%m-%d') - automatic daily backup"
    git push origin main
fi

