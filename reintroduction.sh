#!/bin/bash

search_string="$1"
file_name="$2"

if [ -z "$search_string" ] || [ -z "$file_name" ]; then
    echo "Usage: $0 <search_string> <file_name>"
    exit 1
fi

# Get all commits that change the file, in reverse chronological order
commits=$(git log --format="%H" --reverse -- "$file_name")

latest_introduction=""
for commit in $commits; do
    # Check if the string exists in this commit
    if git show "$commit:$file_name" 2>/dev/null | grep -q "$search_string"; then
        latest_introduction=$commit
    fi
done

if [ -n "$latest_introduction" ]; then
    echo "String last introduced or present in commit: $latest_introduction"
    git show $latest_introduction
else
    echo "String not found in any commit"
fi