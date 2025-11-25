#!/bin/bash

select_options () {
    # Keep asking for input until a valid option is selected
    option=-1;
    while [ $option -lt 1 ] || [ $option -gt 6 ]; do
    read -p "Enter an option: " option;

    if [ $option -lt 1 ] || [ $option -gt 6 ]; then
        printf 'Invalid Option\n\n';
    fi
    done

    echo $option;
}