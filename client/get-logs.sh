#!/bin/bash
# File containing key-value pairs
file_path="nodes"

# Loop through each line in the file
while IFS=' ' read -r node ip; do
    # Run the curl command for each node
    curl -o "${node}.zip" "http://${ip}:8000/export/all"
done < "$file_path"

