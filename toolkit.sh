#!/bin/bash
# ============================================================
#  Bash Multi-Tool Command Center
#  Author: Your Name
#  Version: 2.1
#  Description: Auto-discovers scripts in 'features' folder,
#               logs all activity, checks for updates,
#               and provides a dynamic menu.
# ============================================================

SCRIPT_NAME="Home Command Center"
SCRIPT_VERSION="2.1"
FEATURES_DIR="$(dirname "$0")/features"
LOG_FILE="$(dirname "$0")/toolkit.log"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
NC="\033[0m"

pause() { read -rp "Press [Enter] to continue..."; }

print_header() {
    clear
    echo -e "${BLUE}============================"
    echo -e "  $SCRIPT_NAME v$SCRIPT_VERSION"
    echo -e "============================${NC}"
    echo
}

log_action() {
    local action="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $action" >> "$LOG_FILE"
}

invalid_option() {
    echo -e "${RED}Invalid option. Please try again.${NC}"
    pause
}

run_feature() {
    local script="$1"
    echo -e "${GREEN}Running: $script${NC}"
    log_action "Running feature: $(basename "$script")"
    bash "$script"
    pause
}

check_for_updates() {
    local repo_dir
    repo_dir="$(dirname "$0")"

    if [ -d "$repo_dir/.git" ]; then
        git -C "$repo_dir" fetch --quiet
        LOCAL=$(git -C "$repo_dir" rev-parse @)
        REMOTE=$(git -C "$repo_dir" rev-parse @{u} 2>/dev/null)

        if [ "$LOCAL" != "$REMOTE" ]; then
            echo -e "${YELLOW}Update available! Run 'toolkit-update' to get the latest version.${NC}"
            pause
        fi
    fi
}

# --- MAIN PROGRAM ---
check_for_updates

while true; do
    print_header
    mkdir -p "$FEATURES_DIR"

    scripts=("$FEATURES_DIR"/*.sh)
    if [ ${#scripts[@]} -eq 0 ] || [ ! -f "${scripts[0]}" ]; then
        echo -e "${YELLOW}No feature scripts found in $FEATURES_DIR${NC}"
        echo "Add .sh scripts to this folder to see them here."
        echo
    else
        echo "Available Features:"
        i=1
        for script in "${scripts[@]}"; do
            echo "$i) $(basename "$script")"
            ((i++))
        done
        echo "$i) Exit"
        echo "----------------------------"
        
        read -rp "Choose an option [1-$i]: " choice

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$i" ]; then
            if [ "$choice" -eq "$i" ]; then
                log_action "Exited toolkit"
                echo "Goodbye!"
                exit 0
            else
                run_feature "${scripts[$((choice-1))]}"
            fi
        else
            invalid_option
        fi
    fi
done
