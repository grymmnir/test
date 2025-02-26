#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 <directory_path> <search_string>"
    echo "Example: $0 /tmp/logs 'Chrome/'"
    exit 1
}

# Function to validate directory
validate_directory() {
    if [ ! -d "$1" ]; then
        echo "Error: Directory '$1' does not exist or is not accessible."
        exit 1
    fi
}

# Function to process log files and display stats
process_logs() {
    local dir="$1"
    local search_str="$2"

    # Print header
    printf "%-30s %-10s %-10s %-10s\n" "File Name" "Size" "Lines" "Search Count"

    # Collect stats for each file
    declare -a stats
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            file_size=$(du -h "$file" | cut -f1)
            total_lines=$(wc -l < "$file")
            search_count=$(grep -c "$search_str" "$file")
            stats+=("$(printf "%-30s %-10s %-10s %-10s" "$file" "$file_size" "$total_lines" "$search_count")")
        fi
    done < <(find "$dir" -type f)

    # Sort stats by "Search Count" column (descending order)
    IFS=$'\n' sorted_stats=($(sort -k4,4nr <<<"${stats[*]}"))
    unset IFS

    # Print sorted stats
    for stat in "${sorted_stats[@]}"; do
        echo "$stat"
    done
}

# Main script logic
main() {
    # Check if the correct number of arguments is provided
    if [ "$#" -ne 2 ]; then
        usage
    fi

    # Assign arguments to variables
    log_dir="$1"
    search_string="$2"

    # Validate the directory
    validate_directory "$log_dir"

    # Process log files and display stats
    process_logs "$log_dir" "$search_string"
}

# Execute the script
main "$@"
