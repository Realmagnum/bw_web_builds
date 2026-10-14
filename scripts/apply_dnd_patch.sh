#!/usr/bin/env bash
set -o pipefail -o errexit
BASEDIR=$(RL=$(readlink -n "$0"); SP="${RL:-$0}"; dirname "$(cd "$(dirname "${SP}")"; pwd)/$(basename "${SP}")")

# Apply drag-and-drop patches to web-vault after checkout
echo "Applying drag-and-drop patches..."

VAULT_DIR="${BASEDIR}/web-vault"
PATCHES_DIR="${BASEDIR}/patches-dragdrop"

if [ ! -d "${VAULT_DIR}" ]; then
    echo "ERROR: ${VAULT_DIR} not found. Run checkout first."
    exit 1
fi

# Patch files will be applied using simple file copy from patches-dragdrop/
for src in "${PATCHES_DIR}"/*; do
    filename=$(basename "$src")
    rel_path=$(echo "$filename" | sed 's|.*_||')
    if [ -f "$src" ] && [ -n "$rel_path" ]; then
        dst="${VAULT_DIR}/${rel_path}"
        mkdir -p "$(dirname "$dst")"
        cp -v "$src" "$dst"
        echo "Applied: $rel_path"
    fi
done

echo "Drag-and-drop patches applied successfully!"
