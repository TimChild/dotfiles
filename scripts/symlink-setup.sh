#!/bin/bash
# This script will symlink any ~/<files> from the `dotfiles/home` directory to `~` as well as any explicit paths/files listed below

##### Explicitly list directories to symlink #####
declare -a explicit_paths=(".config/nvim" ".config/tmux" ".ssh/config")
##################################################


# Directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dotfiles directory (i.e. the files to make links to)
DOTFILES_DIR="$DIR/../home"

# Backup directory in case a file already exists and needs to be backed up before creating symlink
BACKUP_DIR="$DIR/../overwritten-files"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create symlinks for individual files
for file in $(find $DOTFILES_DIR -maxdepth 1 -type f); do
    filename=$(basename $file)
    
    if [ -e "$HOME/$filename" ]; then
        echo "$filename already exists in home directory. Backing up..."
        mv "$HOME/$filename" "$BACKUP_DIR/"
    fi
    
    ln -s "$DOTFILES_DIR/$filename" "$HOME/$filename"
    echo "Symlink created for $filename"
done


for dir in "${explicit_paths[@]}"; do
    if [ -e "$HOME/$dir" ]; then
        echo "$dir already exists in home directory. Backing up..."
        mv "$HOME/$dir" "$BACKUP_DIR/"
    fi

    ln -s "$DOTFILES_DIR/$dir" "$HOME/$dir"
    echo "Symlink created for $dir"
done

echo "Symlink setup complete."

