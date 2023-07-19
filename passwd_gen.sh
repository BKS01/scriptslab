#!/bin/bash

# Default values
length=10
num_passwords=5

# Help message
function show_help {
    echo "Usage: $0 [-l <length>] [-n <num_passwords>] [-h]"
    echo "Generate passwords containing uppercase and lowercase Latin letters and Arabic digits."
    echo "Options:"
    echo "  -l <length>         Set the length of each password (default: 10)"
    echo "  -n <num_passwords>  Set the number of passwords to generate (default: 5)"
    echo "  -h                  Show this help message"
    echo "Author:BKS01"
}

# Parse command-line arguments
while getopts "l:n:h" opt; do
    case "$opt" in
        l) length=$OPTARG ;;
        n) num_passwords=$OPTARG ;;
        h) show_help; exit 0 ;;
        \?) echo "Error: Invalid option -$OPTARG" >&2; exit 1 ;;
        :) echo "Error: Option -$OPTARG requires an argument" >&2; exit 1 ;;
    esac
done

# Check if the length and num_passwords are positive integers
if ! [[ $length =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Invalid length value. Length must be a positive integer." >&2
    exit 1
fi

if ! [[ $num_passwords =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Invalid num_passwords value. The number of passwords must be a positive integer." >&2
    exit 1
fi

# Function to generate a random password
function generate_password {
    local length=$1
    cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w "$length" | head -n 1
}

# Generate and print passwords
for ((i=1; i<=num_passwords; i++)); do
    password=$(generate_password "$length")
    echo "$password"
done

exit 0

