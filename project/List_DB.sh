#!/bin/bash


options=($(ls -F "./DataBases" | grep '/' | tr '/' ' '))

if [ ${#options[@]} -eq 0 ]; then
    echo -e "\e[1;31mNo databases to List. Create a DataBase first.\e[0m"
    
else
    echo -e "\e[93m------List DataBase------\e[0m"

    for ((i = 0; i < ${#options[@]}; i++)); do  
        echo "$((i+1))) ${options[i]}"
    done
fi

exec "$PWD/main.sh"