#!/bin/bash

# Load helper functions (group management, logging, etc.)
. ./functions.sh

# Top bound for introduction
printf '=%.0s' {1..50}
printf '\nSOFE 3200: Systems Programming, Group 15\n'
printf 'Description: Simple bash script to manage user accounts\n'
printf 'Usage: sudo ./main.sh\n'
# Bottom bound for introduction
printf '=%.0s' {1..50}
printf '\n'

# Main menu loop
while true; do
    printf '\nOptions:\n'
    printf '1: Add User\n'
    printf '2: Modify User\n'
    printf '3: Delete User\n'
    printf '4: List All Users\n'
    printf '5: Create Group\n'
    printf '6: Delete Group\n'
    printf '7: Add User to Group\n'
    printf '8: List Groups for a User\n'
    printf '9: Exit\n'

    option=0
    while [ "$option" -lt 1 ] || [ "$option" -gt 9 ]; do
        read -rp "Enter an option: " option

        # Check that option is a number
        if ! [[ "$option" =~ ^[0-9]+$ ]]; then
            echo "Invalid option (must be a number)."
            option=0
            continue
        fi

        if [ "$option" -lt 1 ] || [ "$option" -gt 9 ]; then
            echo "Invalid option. Please try again."
        fi
    done

    case "$option" in
        1)
            # Option 1: Add User
            trap 'echo "An error occurred. Ensure your password is at least 6 characters long. Returning to menu...";' ERR

            first_name=''
            last_name=''
            username=''
            password=''

            read -rp "Enter your first and last name (with a space in between): " first_name last_name
            read -rp "Enter a username: " username

            # Check if user already exists
            if id "$username" &>/dev/null; then
                printf "Error: User '%s' already exists.\n" "$username"
                continue
            fi

            # Create new user
            sudo useradd -m -s /bin/bash "$username"
            if [ $? -ne 0 ]; then
                printf "Error: Failed to add user.\n"
                continue
            fi

            # Get password from user
            read -rsp "Enter a password (minimum of 6 characters): " password
            echo

            # Set the password for the new user
            echo "$username:$password" | sudo chpasswd

            printf "User '%s' added successfully.\n" "$username"
            ;;

        2)
            # Option 2: Modify User
            read -rp "Enter the username you want to modify: " username

            # Check if user exists
            if ! id "$username" &>/dev/null; then
                printf "Error: User '%s' does not exist.\n" "$username"
                continue
            fi

            printf '\nSelect what you want to modify:\n'
            printf '1: Change Password\n'
            printf '2: Change Full Name\n'
            printf '3: Change Shell\n'
            printf '4: Cancel\n'

            read -rp "Enter an option: " modOption

            case "$modOption" in
                1)
                    read -rsp "Enter new password: " newPassword
                    echo
                    echo "$username:$newPassword" | sudo chpasswd
                    printf "Password updated successfully.\n"
                    ;;
                2)
                    read -rp "Enter new first and last name: " newFirst newLast
                    sudo chfn -f "$newFirst $newLast" "$username"
                    printf "Full name updated successfully.\n"
                    ;;
                3)
                    read -rp "Enter new shell (e.g., /bin/bash): " newShell
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
            ;;

        3)
            # Option 3: Delete User
            read -rp "Enter username to delete: " delUser

            if ! id "$delUser" &>/dev/null; then
                printf "Error: User '%s' does not exist.\n" "$delUser"
                continue
            fi

            sudo userdel "$delUser"
            printf "User '%s' deleted successfully.\n" "$delUser"
            ;;

        4)
	    # Option 4: List Users
	    echo "Regular users on this system:"
	    getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 { printf "%-20s %s\n", $1, $6 }'
	    ;;


        5)
            # Option 5: Create Group (implemented in functions.sh)
            create_group
            ;;

        6)
            # Option 6: Delete Group
            delete_group
            ;;

        7)
            # Option 7: Add User to Group
            add_user_to_group
            ;;

        8)
            # Option 8: List Groups for a User
            list_groups_for_user
            ;;

        9)
            printf 'Exiting...\n'
            exit 0
            ;;
    esac
done
