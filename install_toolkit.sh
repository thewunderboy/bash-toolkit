#!/bin/bash
# ============================================================
#  Toolkit Installer
#  Author: Your Name
#  Description: Installs the Home Command Center as 'toolkit'
# ============================================================

TOOLKIT_DIR="$(pwd)"
TOOLKIT_MAIN="$TOOLKIT_DIR/toolkit.sh"
INSTALL_DIR="$HOME/.local/bin"
COMMAND_NAME="toolkit"

mkdir -p "$INSTALL_DIR"
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$HOME/.bashrc"
    export PATH="$PATH:$INSTALL_DIR"
    echo "[Installer] Added $INSTALL_DIR to PATH in ~/.bashrc"
fi

ln -sf "$TOOLKIT_MAIN" "$INSTALL_DIR/$COMMAND_NAME"
chmod +x "$TOOLKIT_MAIN"

# Also install updater
ln -sf "$TOOLKIT_DIR/update_toolkit.sh" "$INSTALL_DIR/toolkit-update"
chmod +x "$TOOLKIT_DIR/update_toolkit.sh"

echo "[Installer] Toolkit installed!"
echo "You can now run: $COMMAND_NAME"
echo "You can update with: toolkit-update"
