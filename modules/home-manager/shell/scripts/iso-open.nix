{pkgs}:
with pkgs;
  writeScriptBin "iso-open" ''
    #!/usr/bin/env bash

    # Extract/copy contents of an ISO file
    # Usage: iso-open <file.iso>

    set -euo pipefail  # Exit on error, undefined variables, and pipe failures

    if [ $# -ne 1 ]; then
        echo "Usage: iso-open <file.iso>"
        exit 1
    fi

    file="$1"

    # Validate input file
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist"
        exit 1
    fi

    # Get the basename without .iso extension
    name=$(basename "$file" .iso)

    # Create destination directory in current working directory
    dest="./$name"

    # Create temporary mount point
    mount_point=$(mktemp -d)

    # Cleanup function to ensure unmounting
    cleanup() {
        if mountpoint -q "$mount_point" 2>/dev/null; then
            echo "Unmounting ISO..."
            sudo umount "$mount_point" 2>/dev/null || true
        fi
        rm -rf "$mount_point"
    }

    # Set trap to cleanup on exit/error
    trap cleanup EXIT INT TERM

    echo "Mounting ISO: $file"
    if ! sudo mount -o loop,ro "$file" "$mount_point"; then
        echo "Error: Failed to mount ISO file"
        exit 1
    fi

    echo "Mounted at: $mount_point"

    # Get ISO size for disk space check
    iso_size=$(du -sb "$mount_point" 2>/dev/null | cut -f1 || echo "0")
    available_space=$(df . | tail -1 | awk '{print $4 * 1024}')

    if [ "$iso_size" -gt "$available_space" ]; then
        echo "Warning: ISO contents ($iso_size bytes) may not fit in available space ($available_space bytes)"
        read -p "Continue anyway? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Operation cancelled by user"
            exit 0
        fi
    fi

    echo "Copying contents to: $dest"

    # Create destination directory
    mkdir -p "$dest"

    # Copy all contents from mounted ISO to destination
    echo "Copying files..."
    copied_files=0

    # Copy regular files and directories
    if ls "$mount_point"/* >/dev/null 2>&1; then
        cp -r "$mount_point"/* "$dest/" && copied_files=1
    fi

    # Copy hidden files (starting with .)
    if ls "$mount_point"/.[^.]* >/dev/null 2>&1; then
        cp -r "$mount_point"/.[^.]* "$dest/" && copied_files=1
    fi

    # Handle case where ISO might be empty or copy failed
    if [ "$copied_files" -eq 0 ]; then
        echo "Warning: No files were copied (ISO might be empty or inaccessible)"
        echo "Contents of mounted ISO:"
        ls -la "$mount_point" || echo "Unable to list mounted ISO contents"
    else
        # Fix file permissions since copied from read-only mount
        echo "Setting proper file permissions..."
        chmod -R u+w "$dest"
        echo "Copy completed successfully"
    fi
    echo "Contents extracted to: $dest"

    # List the copied contents
    echo "Extracted files:"
    ls -alhF "$dest"

    # Cleanup will be called automatically via trap
  ''
