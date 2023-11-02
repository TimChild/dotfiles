#!/bin/bash
# This script will symlink any ~/<files> from the `dotfiles/home` directory to `~` as well as any explicit paths/files listed below

##### Explicitly list directories to symlink #####
declare -a explicit_paths=(".config/nvim" ".config/tmux" ".ssh/config" "backup-scripts")
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


for path in "${explicit_paths[@]}"; do
    if [ -e "$HOME/$path" ]; then
        echo "$path already exists in home directory. Backing up..."

        # Extract directory structure of the file/directory from path
        path_dir=$(dirname "$path")

        # Debugging output
        echo "DEBUG: path_dir = $path_dir"
        echo "DEBUG: BACKUP_DIR/path_dir = $BACKUP_DIR/$path_dir"
        echo "DEBUG: BACKUP_DIR/path = $BACKUP_DIR/$path"

        # Create the directory structure in the backup directory
        mkdir -p "$BACKUP_DIR/$path_dir"

        # Now move the existing file/directory to the backup directory
        mv "$HOME/$path" "$BACKUP_DIR/$path"
    fi

    # Ensure the destination directory exists for the symlink
    mkdir -p "$(dirname "$HOME/$path")"

    ln -s "$DOTFILES_DIR/$path" "$HOME/$path"
    echo "Symlink created for $path"
done

echo "Symlink setup complete."

