#!/bin/bash

get_state_description() {
    local state_symbol="$1"
    case "$state_symbol" in
        R) echo "Running" ;;
        S) echo "Sleeping" ;;
        D) echo "Disk Sleep" ;;
        Z) echo "Zombie" ;;
        T) echo "Stopped" ;;
        t) echo "Tracing Stop" ;;
        W) echo "Paging" ;;
        X) echo "Dead" ;;
        x) echo "Dead (Reserved)" ;;
        K) echo "Wakekill" ;;
        W) echo "Waking" ;;
        P) echo "Parked" ;;
        *) echo "Unknown" ;;
    esac
}

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -n, --name    Show PID and process name."
    echo "  -m, --memory  Show PID and physical memory usage."
    echo "  -s, --state   Show PID and process state."
    echo "  -h, --help    Show this help message."
}

show_column() {
    local column_name="$1"
    echo "PID    $column_name"
    echo "-------------------"
    for pid in /proc/[0-9]*/; do
        pid=$(basename "$pid")
        local column_value
        if [ -f "/proc/$pid/status" ]; then
            column_value=$(awk -v col="$column_name" '$1 == col {print $2}' "/proc/$pid/status")
            printf "%-6s %s\n" "$pid" "$column_value"
        fi
    done
}

show_all_columns() {
    echo "PID    Process Name             Physical Memory    State"
    echo "-------------------------------------------------------"
    for pid in /proc/[0-9]*/; do
        pid=$(basename "$pid")
        local name memory state
        if [ -f "/proc/$pid/status" ]; then
            name=$(awk '$1 == "Name:" { sub(/^[ \t]+/, ""); print }' "/proc/$pid/status")
            memory=$(awk '$1 == "VmRSS:" {print $2}' "/proc/$pid/status")
            state_symbol=$(awk '$1 == "State:" {print $2}' "/proc/$pid/status")
            state=$(get_state_description "$state_symbol")
            printf "%-6s %-24s %-18s %s\n" "$pid" "$name" "$memory kB" "$state"
        fi
    done
}

# Main script logic
if [ "$#" -eq 0 ]; then
    show_all_columns
    exit 0
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        -n|--name)
            show_column "Name:"
            ;;
        -m|--memory)
            show_column "VmRSS:"
            ;;
        -s|--state)
            show_column "State:" | while read -r pid state_symbol; do
                state=$(get_state_description "$state_symbol")
                printf "%-6s %s\n" "$pid" "$state"
            done
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

