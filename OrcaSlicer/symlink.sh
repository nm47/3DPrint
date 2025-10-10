#!/bin/bash

ORCA_USER="$HOME/.config/OrcaSlicer/user/default"
REPO_ORCA="$(cd "$(dirname "$0")" && pwd)"

# Create repo dirs if needed
mkdir -p "$REPO_ORCA"/{filament,machine,process}

# Backup existing if not already symlinks
for dir in filament machine process; do
    if [ -d "$ORCA_USER/$dir" ] && [ ! -L "$ORCA_USER/$dir" ]; then
        cp -r "$ORCA_USER/$dir" "$REPO_ORCA/$dir"
        rm -rf "$ORCA_USER/$dir"
    fi
    ln -sf "$REPO_ORCA/$dir" "$ORCA_USER/$dir"
done

echo "OrcaSlicer configs linked to $REPO_ORCA"
