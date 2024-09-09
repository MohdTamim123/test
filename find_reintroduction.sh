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
    echo "----------------------------------------"
    echo "Results for searching '$search_string' in '$file_name':"
    echo "----------------------------------------"
    echo "Latest introduction found in commit:"
    git log -1 --pretty=format:"Commit: %h%nAuthor: %an%nDate: %ad%nMessage: %s" $latest_introduction
    echo -e "\n----------------------------------------"
else
    echo "String '$search_string' not found in any commit of '$file_name'"
fi