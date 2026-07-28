#!/bin/bash

# Prefer the flatpak config location if OrcaSlicer is installed via flatpak
FLATPAK_CONFIG="$HOME/.var/app/com.orcaslicer.OrcaSlicer/config/OrcaSlicer"
NATIVE_CONFIG="$HOME/.config/OrcaSlicer"

if flatpak info com.orcaslicer.OrcaSlicer &>/dev/null; then
    ORCA_USER="$FLATPAK_CONFIG/user/default"
else
    ORCA_USER="$NATIVE_CONFIG/user/default"
fi

REPO_ORCA="$(cd "$(dirname "$0")" && pwd)"

# Create repo and OrcaSlicer user dirs if needed
mkdir -p "$REPO_ORCA"/{filament,machine,process}
mkdir -p "$ORCA_USER"

# Backup existing if not already symlinks
for dir in filament machine process; do
    if [ -d "$ORCA_USER/$dir" ] && [ ! -L "$ORCA_USER/$dir" ]; then
        cp -r "$ORCA_USER/$dir/." "$REPO_ORCA/$dir/"
        rm -rf "$ORCA_USER/$dir"
    fi
    # Remove a stale/broken symlink so ln doesn't nest
    [ -L "$ORCA_USER/$dir" ] && rm "$ORCA_USER/$dir"
    ln -s "$REPO_ORCA/$dir" "$ORCA_USER/$dir"
done

echo "OrcaSlicer configs linked to $REPO_ORCA (target: $ORCA_USER)"
