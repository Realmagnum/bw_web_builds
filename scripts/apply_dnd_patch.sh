#!/usr/bin/env bash
set -o pipefail -o errexit
BASEDIR=$(RL=$(readlink -n "$0"); SP="${RL:-$0}"; dirname "$(cd "$(dirname "${SP}")"; pwd)/$(basename "${SP}")")

# Apply drag-and-drop patches to web-vault after checkout
echo "Applying drag-and-drop patches..."

REPO_DIR="$(cd "${BASEDIR}/.." && pwd)"
VAULT_DIR="${REPO_DIR}/${VAULT_FOLDER:-web-vault}"
PATCHES_DIR="${REPO_DIR}/patches-dnd"

if [ ! -d "${VAULT_DIR}" ]; then
    echo "ERROR: ${VAULT_DIR} not found. Run checkout first."
    exit 1
fi
if [ ! -d "${PATCHES_DIR}" ]; then
    echo "ERROR: ${PATCHES_DIR} not found."
    exit 1
fi

# Preserve repository-relative paths and fail if any expected source or destination is missing.
while IFS= read -r -d '' src; do
    rel_path="${src#"${PATCHES_DIR}"/}"
    dst="${VAULT_DIR}/${rel_path}"
    mkdir -p "$(dirname "$dst")"
    cp -v -- "$src" "$dst"
    cmp -s -- "$src" "$dst"
    echo "Applied and verified: ${rel_path}"
done < <(find "${PATCHES_DIR}" -type f -print0)

echo "Drag-and-drop patches applied successfully!"
