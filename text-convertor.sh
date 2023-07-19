#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Converts text stream according to the specified rules."
    echo "Options:"
    echo "  -d, --unix2dos   Convert line endings to DOS format (CRLF)"
    echo "  -u, --dos2unix   Convert line endings to UNIX format (LF)"
    echo "  -s, --spaces     Convert multiple spaces to a single space"
    echo "  -m, --minus      Convert multiple dashes to a double dash"
    echo "  -h, --help       Show this help message and exit"
}

# Function to convert line endings to DOS format (CRLF)
unix2dos() {
    tr '\n' '\r\n'
}

# Function to convert line endings to UNIX format (LF)
dos2unix() {
    tr -d '\r'
}

# Function to convert multiple spaces to a single space
convert_spaces() {
    sed -E 's/[[:space:]]+/ /g'
}

# Function to convert multiple dashes to a double dash
convert_minus() {
    sed -E 's/---/--/g'
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Error: No arguments provided. Use '-h' for help."
    exit 1
fi

# Handle command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d | --unix2dos)
            unix2dos
            ;;
        -u | --dos2unix)
            dos2unix
            ;;
        -s | --spaces)
            convert_spaces
            ;;
        -m | --minus)
            convert_minus
            ;;
        -h | --help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Invalid argument: $1. Use '-h' for help."
            exit 1
            ;;
    esac
    shift
done

# If no conversion option is provided
if [ $# -eq 0 ]; then
    echo "Error: No conversion option provided. Use '-h' for help."
    exit 1
fi

# Process the input text stream
cat -

