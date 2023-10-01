#!/bin/bash

# Define the prefix to be added
prefix="cva6"

# Function to recursively process files and update instances
process_file() {
    local file="$1"
    local tmp_file="$(mktemp)"
    
    # Add the prefix to module names inside the file
    awk -v prefix="$prefix" '/^\s*module/ { $2 = prefix "_" $2 } { print }' "$file" > "$tmp_file"
    
    # Replace the original file with the updated file
    mv "$tmp_file" "$file"
}

# Find all SystemVerilog and Verilog files in the current directory and its subdirectories
find . -type f \( -name "*.sv" -o -name "*.v" \) | while read -r file; do
    # Add the prefix to the filename
    new_file="$(dirname "$file")/${prefix}_$(basename "$file")"
    
    # Rename the file
    mv "$file" "$new_file"
    
    # Process the file to update module names
    process_file "$new_file"
done

echo "Prefix 'cva6' added to file names and module names."
