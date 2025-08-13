#!/bin/bash
# ============================================================
#  Toolkit Updater
#  Author: Your Name
#  Description: Pulls the latest changes from GitHub
# ============================================================

TOOLKIT_DIR="$(dirname "$0")/.."
REMOTE_NAME="origin"
BRANCH_NAME="main"

echo "============================"
echo "   Toolkit Auto-Updater"
echo "============================"

if [ ! -d "$TOOLKIT_DIR/.git" ]; then
    echo "[Error] This folder is not a Git repository."
    echo "Clone it from GitHub first:"
    echo "  git clone https://github.com/YOUR_USERNAME/bash-toolkit.git"
    exit 1
fi

echo "[Info] Fetching latest updates..."
git -C "$TOOLKIT_DIR" fetch "$REMOTE_NAME"

echo "[Info] Pulling from $REMOTE_NAME/$BRANCH_NAME..."
git -C "$TOOLKIT_DIR" pull "$REMOTE_NAME" "$BRANCH_NAME"

if [ $? -eq 0 ]; then
    echo "[Success] Toolkit updated successfully!"
else
    echo "[Error] Update failed. Please check your Git configuration."
fi
