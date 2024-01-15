#!/bin/bash


options=($(ls -p "$PWD" | grep -v '/$'))

if [ ${#options[@]} -eq 0 ]; then
    echo -e "\e[1;31mNo tables in this database. Create a table first.\e[0m"
    cd ..
    cd .. 
    exec "$PWD/Connect_DB.sh"

else
    echo -e "\e[93m----List Tables----\e[0m"

    for ((i = 0; i < ${#options[@]}; i++)); do  
        echo "$((i+1))) ${options[i]}"
        cd ..
        cd .. 
        exec "$PWD/Connect_DB.sh"
    done
fi
