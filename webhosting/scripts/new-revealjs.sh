#!/bin/bash
# Copies the latest version of reveal.js to a specified directory (and installs deps)
# First argument is the destination directory, second argument is the subdirectory (optional)
# Note: excludes .git and .github directories

# Check if destination directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <dest_dir>"
  exit 1
fi


DEST_DIR="$1"
SUB_DIR="$2"
TEMP_DIR="/tmp/revealjs_clone"

# If the subdirectory is provided, append it to the destination directory
if [ -n "$SUB_DIR" ]; then
  DEST_DIR="$DEST_DIR/$SUB_DIR"
else
  DEST_DIR="$DEST_DIR/revealjs_slideshow"
fi

# Clone or update the repository
if [ ! -d "$TEMP_DIR/.git" ]; then
  # Clone with minimal depth if it doesn't exist
  gh repo clone hakimel/reveal.js "$TEMP_DIR" -- --depth=1
else
  # Pull latest changes if it already exists
  git -C "$TEMP_DIR" pull
fi

# Copy contents to destination directory, excluding .git and .github
rsync -aq --exclude=".git" --exclude=".github" "$TEMP_DIR/" "$DEST_DIR/"

echo "Reveal.js copied to $DEST_DIR"

# Run npm install in the destination directory
npm audit fix --prefix "$DEST_DIR"
npm install --prefix "$DEST_DIR"

echo "Edit index.html to change the slideshow. Start it by running:"
echo "npm start --prefix $DEST_DIR"


