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
printf '\n\n';

# Display options
printf 'Options: \n'; 
printf '1: Add User\n'; 
printf '2: Modify User\n'; 
printf '3: Delete User\n'; 
printf '4: List All Users\n'; 
printf '5: Exit\n'; 

# Keep asking for input until a valid option is selected
option=-1;
while [ $option -lt 1 ] || [ $option -gt 6 ]; do
read -p "Enter an option: " option;

if [ $option -lt 1 ] || [ $option -gt 6 ]; then
    printf 'Invalid Option\n\n';
fi
done

# Option 1: Add User
if [ $option -eq 1 ]; then
    # Setup a trap in case an error occurs
    trap 'echo "An error occurred. Ensure your password is at least 6 characters long. Exiting..."; exit 1;' ERR;

    # Set variables
    first_name='';
    last_name='';
    username='';
    password='';

    # Get name, username, and password from user
    read -p "Enter your first and last name (with a space in between): " first_name last_name;
    read -p "Enter a username: " username;
    read -sp "Enter a password (minimum of 6 characters): " password;

    # Add a user and set their password
    sudo useradd -m -s /bin/bash "$username";
    echo $username:$password | sudo chpasswd;
fi

# Option 2: Modify User


# Option 3: Delete User


# Option 4: List Users (TEMPORARY)
if [ $option -eq 4 ]; then
    getent passwd;
fi


# Option 5: Exit
if [ $option -eq 5 ]; then
    printf 'Exiting...\n';
    exit 1;
fi