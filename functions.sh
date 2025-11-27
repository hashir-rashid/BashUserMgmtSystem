#!/bin/bash

LOG_FILE="user_mgmt.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

create_group() {
    read -rp "Enter new group name: " group

    if [ -z "$group" ]; then
        echo "Error: group name cannot be empty."
        return 1
    fi

    if getent group "$group" > /dev/null; then
        echo "Error: group '$group' already exists."
        return 1
    fi

    if sudo groupadd "$group"; then
        echo "Group '$group' created successfully."
        log_action "Created group '$group'"
    else
        echo "Error: failed to create group '$group'."
        return 1
    fi
}

delete_group() {
    read -rp "Enter group name to delete: " group

    if [ -z "$group" ]; then
        echo "Error: group name cannot be empty."
        return 1
    fi

    if ! getent group "$group" > /dev/null; then
        echo "Error: group '$group' does not exist."
        return 1
    fi

    if sudo groupdel "$group"; then
        echo "Group '$group' deleted successfully."
        log_action "Deleted group '$group'"
    else
        echo "Error: failed to delete group '$group'."
        return 1
    fi
}

add_user_to_group() {
    read -rp "Enter username: " user
    read -rp "Enter group name: " group

    if [ -z "$user" ] || [ -z "$group" ]; then
        echo "Error: username and group must not be empty."
        return 1
    fi

    if ! id "$user" &>/dev/null; then
        echo "Error: user '$user' does not exist."
        return 1
    fi

    if ! getent group "$group" > /dev/null; then
        echo "Error: group '$group' does not exist."
        return 1
    fi

    if sudo usermod -aG "$group" "$user"; then
        echo "User '$user' added to group '$group'."
        log_action "Added user '$user' to group '$group'"
    else
        echo "Error: failed to add user '$user' to group '$group'."
        return 1
    fi
}

remove_user_from_group() {
    read -rp "Enter username: " user
    read -rp "Enter group name: " group

    # Check if fields are empty
    if [ -z "$user" ] || [ -z "$group" ]; then
        echo "Error: username and group must not be empty."
        return 1
    fi

    # Check if user exists
    if ! id "$user" &>/dev/null; then
        echo "Error: user '$user' does not exist."
        return 1
    fi

    # Check if group exists
    if ! getent group "$group" > /dev/null; then
        echo "Error: group '$group' does not exist."
        return 1
    fi

    # Check if user belongs to specified group
    if ! (id -nG "$user" | grep -qw "$group"); then
        echo $user does not belong to $group
        return 1
    fi

    if sudo gpasswd --delete "$user" "$group"; then
        echo "User '$user' removed to group '$group'."
        log_action "Removed user '$user' to group '$group'"
    else
        echo "Error: failed to remove user '$user' from group '$group'."
        return 1
    fi
}

list_groups_for_user() {
    read -rp "Enter username: " user

    if [ -z "$user" ]; then
        echo "Error: username cannot be empty."
        return 1
    fi

    if ! id "$user" &>/dev/null; then
        echo "Error: user '$user' does not exist."
        return 1
    fi

    echo "Groups for user '$user':"
    groups "$user"
}
