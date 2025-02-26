#!/bin/bash

# Check if correct number of arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <log_directory> <search_string>"
    exit 1
fi

log_dir="$1"
search="$2"

# Validate log directory
if [ ! -d "$log_dir" ]; then
    echo "Error: Directory '$log_dir' does not exist."
    exit 1
fi

# Process each file in the directory
(for file in "$log_dir"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        size=$(ls -lh "$file" | awk '{print $5}')
        lines=$(wc -l < "$file")
        count=$(grep -c -- "$search" "$file")
        printf "%s\t%s\t%s\t%s\n" "$filename" "$size" "$lines" "$count"
    fi
done) | sort -t$'\t' -k4,4nr | awk -F'\t' 'BEGIN { 
    printf "%-20s %-10s %-10s %-10s\n", "File", "Size", "Lines", "Count"
} 
{ 
    printf "%-20s %-10s %-10s %-10s\n", $1, $2, $3, $4 
}'