#!/bin/bash
# Usage: ./symlink.sh --printer [vt|VT|v0|V0]
#    or: ./symlink.sh (interactive)

# Printer mappings
declare -A PRINTER_MAP=(
    ["VT"]="VT629"
    ["V0"]="V0585"
)

# Function to setup symlinks
setup_symlinks() {
    local printer_name="$1"
    local source_dir="$HOME/3DPrint/$printer_name/klipper_config"
    local target_dir="$HOME/printer_data/config"
    
    # Check if source directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Error: Directory $source_dir does not exist"
        return 1
    fi
    
    # Create the target directory if it doesn't exist
    mkdir -p "$target_dir"
    
    echo "Setting up symlinks for $printer_name..."
    echo "Source: $source_dir"
    echo "Target: $target_dir"
    echo
    
    # Create symlinks
    for file in "$source_dir"/*; do
        if [ -e "$file" ]; then
            file_name=$(basename "$file")
            ln -sf "$file" "$target_dir/$file_name"
            echo "Linked: $file_name"
        fi
    done
    
    echo
    echo "Symlinks created for $printer_name"
}

# Function to show available printers
show_available_printers() {
    echo "Available printer configurations:"
    echo "---------------------------------"
    for key in "${!PRINTER_MAP[@]}"; do
        local dir="$HOME/3DPrint/${PRINTER_MAP[$key]}/klipper_config"
        if [ -d "$dir" ]; then
            echo "  $key -> ${PRINTER_MAP[$key]}"
        fi
    done
    echo
}

# Main script logic
PRINTER_TYPE=""
PRINTER_NAME=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --printer)
            PRINTER_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --printer [vt|VT|v0|V0]  Specify printer type"
            echo "  -h, --help               Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --printer vt          Setup VT629"
            echo "  $0 --printer v0          Setup V0585"
            echo "  $0                       Interactive mode"
            echo ""
            show_available_printers
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# If printer type was provided via argument
if [ -n "$PRINTER_TYPE" ]; then
    # Normalize to uppercase
    PRINTER_TYPE=$(echo "$PRINTER_TYPE" | tr '[:lower:]' '[:upper:]')
    
    # Check if it's a valid printer type
    if [[ -n "${PRINTER_MAP[$PRINTER_TYPE]}" ]]; then
        PRINTER_NAME="${PRINTER_MAP[$PRINTER_TYPE]}"
    else
        echo "Error: Invalid printer type '$PRINTER_TYPE'"
        echo "Valid options are: VT, V0"
        echo
        show_available_printers
        exit 1
    fi
else
    # Interactive mode - ask user to select
    echo "========================================="
    echo "    Klipper Config Symlink Setup"
    echo "========================================="
    echo
    echo "Select printer:"
    echo "  1) VT (VT629)"
    echo "  2) V0 (V0585)"
    echo
    read -p "Enter your choice (1 or 2): " choice
    
    case "$choice" in
        1)
            PRINTER_NAME="${PRINTER_MAP["VT"]}"
            ;;
        2)
            PRINTER_NAME="${PRINTER_MAP["V0"]}"
            ;;
        *)
            echo "Error: Invalid choice. Please enter 1 or 2"
            exit 1
            ;;
    esac
fi

# Setup the symlinks
setup_symlinks "$PRINTER_NAME"
