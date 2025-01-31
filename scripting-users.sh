#!/bin/bash

# Define the input file
INPUT_FILE="users.txt"

# Function to check if email is valid (FQDN)
validate_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Read the file line by line
while IFS=',' read -r name email id; do
    # Trim spaces
    name=$(echo "$name" | xargs)
    email=$(echo "$email" | xargs)
    id=$(echo "$id" | xargs)
    
    # Skip the header line
    if [[ "$name" == "name" ]]; then
        continue
    fi
    
    # Check if ID is a valid number
    if [[ "$id" =~ ^[0-9]+$ ]]; then
        if (( id % 2 == 0 )); then
            parity="even"
        else
            parity="odd"
        fi
        
        # Validate email
        if validate_email "$email"; then
            echo "The $id of $email is $parity number."
        else
            echo "Warning: Invalid email '$email' for user '$name'." >&2
        fi
    else
        echo "Warning: Invalid ID '$id' for user '$name'." >&2
    fi

done < "$INPUT_FILE"
