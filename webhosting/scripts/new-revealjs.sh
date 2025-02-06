#!/bin/bash
# Copies the latest version of reveal.js to a specified directory

# Check if destination directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <dest_dir>"
  exit 1
fi

DEST_DIR="$1"/reveal_slideshow
TEMP_DIR="/tmp/revealjs_clone"

# Clone or update the repository
if [ ! -d "$TEMP_DIR/.git" ]; then
  # Clone with minimal depth if it doesn't exist
  gh repo clone hakimel/reveal.js "$TEMP_DIR" -- --depth=1
else
  # Pull latest changes if it already exists
  git -C "$TEMP_DIR" pull
fi

# Copy contents to destination directory, excluding .git and .github
rsync -avq --exclude=".git" --exclude=".github" "$TEMP_DIR/" "$DEST_DIR/"

echo "Reveal.js copied to $DEST_DIR"

# Run npm install in the destination directory
npm audit fix --prefix "$DEST_DIR"
npm install --prefix "$DEST_DIR"

echo "Edit index.html to change the slideshow. Start it by running:"
echo "npm start --prefix $DEST_DIR"


