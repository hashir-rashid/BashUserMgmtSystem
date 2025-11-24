#!/bin/bash

# Top bound for introduction
printf '=%.0s' {1..50};

printf '\nSOFE 3200: Systems Programming, Group 15\n';
printf 'Simple bash script to manage user accounts\n';
printf 'Usage: TEMP\n';

# Bottom bound for introduction
printf '=%.0s' {1..50};
printf '\n\n';

# Display options
printf 'Options: \n'; 
printf '1: Add User\n'; 
printf '2: Modify User\n'; 
printf '3: Delete User\n'; 
printf '4: List Wsers\n'; 
printf '5: Exit\n'; 

# Keep asking for input until a valid option is selected
option=-1;
while [ $option -lt 1 ] || [ $option -gt 6 ]; 
do
read -p "Enter an option: " option;

if [ $option -lt 1 ] || [ $option -gt 6 ]; then
    printf 'Invalid Option\n\n';
fi
done

# Option 1: Add User
add_user() {
    read -p "Enter new username: " username
    read -p "Enter full name: " fullname

    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "Error: User '$username' already exists."
        return
    fi

    # Create user
    useradd -m -c "$fullname" "$username"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to add user."
        return
    fi

    # Set password securely
    passwd "$username"
    echo "User '$username' added successfully."



# Option 2: Modify User


# Option 3: Delete User


# Option 4: List Users


# Option 5: Exit
printf 'Exiting...\n';
exit 1;
