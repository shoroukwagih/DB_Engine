#!/bin/bash


options=($(ls -p "$PWD" | grep -v '/$'))

if [ ${#options[@]} -eq 0 ]; then
    echo -e "\e[1;31mNo Table to Drop, Create a Table first\e[0m"
    cd ..
    cd .. 
    exec "$PWD/Connect_DB.sh"
else
    echo -e "\e[93m-----Select a Table to drop----- \e[0m"
    for ((i = 0; i < ${#options[@]}; i++)); do  
        echo "$((i+1)) ) ${options[i]}"
    done

    echo "$((i+1)) ) Remove All Tables"

    read -p $'\e[38;5;208mEnter the number of the table you want to Drop (0 to Back to Connect menu): \e[0m' choice

    if [[ $choice =~ ^[0-$((i+1))]$ ]]; then
        if [ $choice -eq 0 ]; then
            echo "Back to Connect menu"
            cd ..
            cd .. 
            exec "$PWD/Connect_DB.sh"
        elif [ $choice -le $i ]; then
            name="${options[choice-1]}"
            
            rm "$(pwd)/$name"
            echo -e "\e[1;32mRemove Table \"$name\"\e[0m"
        else
            echo -e "\e[1;32mRemoving All Tables\e[0m"
            find "$(pwd)" -maxdepth 1 -type f -delete
            echo -e "\e[1;32mAll Files removed\e[0m"
            cd ..
            cd .. 
            exec "$PWD/Connect_DB.sh"
        fi
    else
        echo -e "\e[1;31mError: Invalid choice. Please enter a valid number.\e[0m"
        cd ..
        cd .. 
        exec "$PWD/Connect_DB.sh"
    fi
fi

