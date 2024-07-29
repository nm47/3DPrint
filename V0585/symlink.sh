#!/bin/bash

SOURCE_DIR="klipper_config"
TARGET_DIR="$HOME/klipper_config"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

for file in "$SOURCE_DIR"/*; 
do
  file_name=$(basename "$file")
  
  # Create the symlink, overwrite if the file already exists
  ln -sf $(realpath "$file") "$TARGET_DIR/$file_name"
done

echo "Symlinks created, restart klipper."
