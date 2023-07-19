#!/bin/bash

# Function to display help on how to use the script
print_help() {
  echo "Usage: $0 <command>"
  echo "Wrapper script to measure the execution time of a command."
  echo "Example: $0 ls -l"
}

# Check if there are no command-line arguments or if the argument is -h or --help
if [[ $# -eq 0 || $1 == "-h" || $1 == "--help" ]]; then
  print_help
  exit 0
fi

# Save the command passed as arguments in the variable command_to_run
command_to_run="$@"

# Record the current start time of command execution in the start_time variable
start_time=$(date +%s.%N)

# Execute the command using eval (converts a string to a command)
eval "$command_to_run"

# Record the current end time of command execution in the end_time variable
end_time=$(date +%s.%N)

# Calculate the execution time of the command using bc for precise floating-point arithmetic
execution_time=$(echo "scale=4; $end_time - $start_time" | bc)

# Display the execution time on the screen
echo "Execution time: ${execution_time} seconds"

