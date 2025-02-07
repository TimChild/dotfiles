#!/bin/bash
# Copies the latest version of reveal.js to a specified directory (and installs deps)
# First argument is the destination directory, second argument is the subdirectory (optional)
# Note: excludes .git, .github, and demo.html from the copy
#

# Check arguments passed
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <template_dir> <dest_dir> [sub_dir]"
  exit 1
fi

TEMPLATE_DIR="$1"
DEST_DIR="$2"
SUB_DIR="$3"
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
rsync -aq \
  --exclude=".git" --exclude=".github" --exclude="demo.html" --exclude="examples" --exclude="test"\
  "$TEMP_DIR/" "$DEST_DIR/"

echo "Reveal.js copied to $DEST_DIR"

# Run npm install in the destination directory
npm audit fix --prefix "$DEST_DIR"
npm install --prefix "$DEST_DIR"

# Copy the template files to the destination directory
rsync -aq "$TEMPLATE_DIR/" "$DEST_DIR/"

echo "Edit 'content/slides.md' to change the slideshow (or modify 'index.html'). Start it by running:"
echo "npm start --prefix $DEST_DIR"
echo "Note: Examples can be found in $TEMP_DIR/examples"


