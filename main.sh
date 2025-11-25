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

    # Keep asking for input until a valid option is selected
    option=-1;
    while [ $option -lt 1 ] || [ $option -gt 5 ]; do
        read -p "Enter an option: " option;

        if [ $option -lt 1 ] || [ $option -gt 5 ]; then
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

        # Get name and username from user
        read -p "Enter your first and last name (with a space in between): " first_name last_name;
        read -p "Enter a username: " username;

        # Check if user already exists
        if id "$username" &>/dev/null; then
            printf "Error: User $username already exists";
            exit 1;
        fi

        # Create new user
        sudo useradd -m -s /bin/bash "$username";
        if [[ $? -ne 0 ]]; then
            printf "Error: Failed to add user"
        fi

        # Get password from user
        read -sp "Enter a password (minimum of 6 characters): " password;

        # Set the password for the new user
        echo $username:$password | sudo chpasswd;

        printf "User '$username' added successfully\n"
    fi

    # Option 2: Modify User
    if [ $option -eq 2 ]; then
        # Get the user to modify
        read -p "Enter the username you want to modify: " username

        # Check if user exists
        if ! id "$username" &>/dev/null; then
            printf "Error: User '%s' does not exist\n" "$username"
            exit 1
        fi

        # Display modification options
        printf '\nSelect what you want to modify:\n'
        printf '1: Change Password\n'
        printf '2: Change Full Name\n'
        printf '3: Change Shell\n'
        printf '4: Cancel\n'
        
        read -p "Enter an option: " modOption

        case $modOption in
            1)
                read -sp "Enter new password: " newPassword
                echo ""
                echo "$username:$newPassword" | sudo chpasswd
                printf "Password updated successfully.\n"
                ;;

            2)
                read -p "Enter new first and last name: " newFirst newLast
                sudo chfn -f "$newFirst $newLast" "$username"
                printf "Full name updated successfully.\n"
                ;;

            3)
                read -p "Enter new shell (e.g., /bin/bash): " newShell
                sudo chsh -s "$newShell" "$username"
                printf "Shell updated successfully.\n"
                ;;

            4)
                printf "Modification cancelled.\n"
                ;;

            *)
                printf "Invalid option.\n"
                ;;
        esac
    fi

    # Option 3: Delete User
    if [ $option -eq 3 ]; then
        read -p "Enter username to delete: " delUser;

        if ! id "$delUser" &>/dev/null; then
            printf "Error: User '%s' does not exist.\n" "$delUser";
            exit 1;
        fi

        sudo userdel "$delUser";
        printf "User '%s' deleted successfully.\n" "$delUser";
    fi

    # Option 4: List Users (TEMPORARY)
    if [ $option -eq 4 ]; then
        getent passwd;
    fi

    # Option 5: Exit
    if [ $option -eq 5 ]; then
        printf 'Exiting...\n';
        exit 1;
    fi
done