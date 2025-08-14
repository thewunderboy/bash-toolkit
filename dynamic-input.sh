#!/bin/bash
# ==========================================================
# Dynamic Multi-Source Input Script Template
# Supports:
#   - Positional parameters
#   - File(s) with CSV + comment/blank filtering
#   - Interactive user entry (-i flag)
# Mix-and-match allowed.
#
# Usage:
#   ./script.sh arg1 arg2 ...
#   ./script.sh file1.txt
#   ./script.sh -i
#   ./script.sh apple file1.txt orange -i
#
# Author: YOUR_NAME
# Version: 1.0
# ==========================================================

# -------------------------------
# Function: process_inputs
# Modify this to suit your actual processing needs
# -------------------------------
process_inputs() {
    echo "Processing inputs..."
    for input in "$@"; do
        echo " - $input"
    done
}

# -------------------------------
# Function: clean_array
# Removes blanks, trims spaces, skips comments
# -------------------------------
clean_array() {
    local raw_inputs=("$@")
    local cleaned=()
    for item in "${raw_inputs[@]}"; do
        # Trim spaces
        item="$(echo "$item" | xargs)"
        # Ignore empty or commented lines
        [[ -z "$item" || "$item" =~ ^# ]] && continue
        cleaned+=("$item")
    done
    echo "${cleaned[@]}"
}

# -------------------------------
# Function: from_file
# Reads file, supports CSV + filtering
# -------------------------------
from_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "[ERROR] File not found: $file"
        exit 1
    fi
    echo "[INFO] Reading inputs from file: $file"
    
    local inputs=()
    while IFS= read -r line; do
        # Split CSV into separate items
        IFS=',' read -ra parts <<< "$line"
        for part in "${parts[@]}"; do
            inputs+=("$part")
        done
    done < "$file"
    
    clean_array "${inputs[@]}"
}

# -------------------------------
# Function: from_user
# Interactive prompt for inputs
# -------------------------------
from_user() {
    echo "[INFO] Reading inputs interactively"
    local inputs=()
    while true; do
        read -p "Enter input (or press Enter to finish): " value
        [[ -z "$value" ]] && break
        inputs+=("$value")
    done
    clean_array "${inputs[@]}"
}

# -------------------------------
# Main logic
# -------------------------------
main() {
    local all_inputs=()

    if [[ $# -eq 0 ]]; then
        user_inputs=($(from_user))
        all_inputs+=("${user_inputs[@]}")
    else
        for arg in "$@"; do
            if [[ -f "$arg" ]]; then
                file_inputs=($(from_file "$arg"))
                all_inputs+=("${file_inputs[@]}")
            elif [[ "$arg" == "-i" ]]; then
                user_inputs=($(from_user))
                all_inputs+=("${user_inputs[@]}")
            else
                all_inputs+=("$arg")
            fi
        done
    fi

    # Final cleaning pass
    all_inputs=($(clean_array "${all_inputs[@]}"))

    process_inputs "${all_inputs[@]}"
}

# Run script
main "$@"