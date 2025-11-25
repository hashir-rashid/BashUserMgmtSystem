#!/bin/bash

# Load helper functions
. ./functions.sh;

# Top bound for introduction
printf '=%.0s' {1..50};

printf '\nSOFE 3200: Systems Programming, Group 15\n';
printf 'Description: Simple bash script to manage user accounts\n';
printf 'Usage: TEMP\n';

# Bottom bound for introduction
printf '=%.0s' {1..50};
printf '\n';

# Loop infinitely unless user exits the program (Option 5)
while [ 1 ]; do
    # Display options
    printf '\nOptions: \n'; 
    printf '1: Add User\n'; 
    printf '2: Modify User\n'; 
    printf '3: Delete User\n'; 
    printf '4: List All Users\n'; 
    printf '5: Exit\n';

    # Get selected option from user
    selected_option=$(select_options);

    # Option 1: Add User
    if [ $selected_option -eq 1 ]; then
        # Setup a trap in case an error occurs
        trap 'echo "An error occurred. Ensure your password is at least 6 characters long. Exiting..."; exit 1;' ERR;

        # Set variables
        first_name='';
        last_name='';
        username='';
        password='';

        # Get name and username from user
        read -p "Enter your first and last name (with a space in between): " first_name last_name;
        read -p "Enter a username: " username;

        # Check if user already exists
        if id "$username" &>/dev/null; then
            echo "Error: User '$username' already exists.";
            exit 1;
        fi

        # Get password from user
        read -sp "Enter a password (minimum of 6 characters): " password;

        # Add a user and set their password
        sudo useradd -m -s /bin/bash "$username";
        echo $username:$password | sudo chpasswd;
    fi

    # Option 2: Modify User
    if [ $selected_option -eq 2 ]; then
        # Get the user to modify
        read -p "Enter the username you want to modify: " username

    # Option 3: Delete User
    if [ $option -eq 3 ]; then
        read -p "Enter username to delete: " delUser

        if ! id "$delUser" &>/dev/null; then
            printf "Error: User '%s' does not exist.\n" "$delUser"
            exit 1
        fi

        sudo userdel -r "$delUser"
        printf "User '%s' deleted successfully.\n" "$delUser"
    fi

    # Option 4: List Users (TEMPORARY)
    if [ $selected_option -eq 4 ]; then
        getent passwd;
    fi

    # Option 5: Exit
    if [ $selected_option -eq 5 ]; then
        printf 'Exiting...\n';
        exit 1;
    fi
done