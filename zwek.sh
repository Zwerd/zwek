#!/bin/bash

# Usage message
usage() {
    echo "Usage: $0 <engine> <url> <wordlist or directory> <options>"
    echo "Engines: dirb, dirbuster, gobuster, dirsearch, feroxbuster."
    echo "Options: -k html, -d, -e, etc."
    echo "Note: Options -u, -w, and -o are reserved. Please choose different options."
}

# Check if there are enough arguments
if [ "$#" -lt 4 ]; then
    usage
    exit 1
fi

# Assigning arguments to variables
engine="$1"
url="$2"
wordlist_or_dir="$3"
options="${@:4}"  # Collect all options

# Validate engine
case $engine in
    dirb|dirbuster|gobuster|dirsearch|feroxbuster)
        ;;
    *)
        echo "Invalid engine: $engine"
        usage
        exit 1
        ;;
esac

# Function to generate output filename
generate_output_filename() {
    local engine=$1
    local url=$2
    local wordlist=$3
    local basename="${wordlist##*/}"
    echo "${engine}_$(echo $url|sed 's/.*:\://'|cut -d"/" -f3)_${basename%.*}.txt"
}

# Check if the wordlist or directory is within /usr/share/wordlists
if [[ "$wordlist_or_dir" == "/usr/share"* ]]; then
    if [ ! -f "$wordlist_or_dir" ]; then
        echo "Wordlist '$wordlist_or_dir' not found."
        usage
        exit 1
    fi

    # Run with single wordlist
    echo "Running $engine with $url and $wordlist_or_dir"
    output_file=$(generate_output_filename "$engine" "$url" "$wordlist_or_dir")
    "$engine" -u "$url" -w "$wordlist_or_dir" -o "$(pwd)/$output_file" $options
else
    # Run with multiple wordlists in directory
    echo "Running $engine with $url and wordlists in directory $wordlist_or_dir"
    for wordlist in $(find "/usr/share/$wordlist_or_dir/" -type f -name "*.txt"); do
        filename=$(basename "$wordlist")
        echo "Running $engine with $url and $filename"
        output_file=$(generate_output_filename "$engine" "$url" "$filename")
	echo $output_file
	"$engine" -u "$url" -w "$wordlist" -o "$(pwd)/$output_file" $options
        sleep 5  # Optional delay
    done
fi
