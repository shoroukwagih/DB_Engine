#!/bin/bash



options=($(ls -F "./DataBases" | grep '/' | tr '/' ' '))
if [ ${#options[@]} -eq 0 ]; then
    echo -e "\e[1;31mNo databases to Drop, Create a DataBase first\e[0m"
    exec "$PWD/main.sh"
else
    echo -e "\e[93m-----Drop DataBase-----\e[0m"

    for ((i = 0; i < ${#options[@]}; i++)); do  
        echo "$((i+1)) ) ${options[i]}"
    done

    echo "$((i+1)) ) Remove All Databases"
    read -p $'\e[38;5;208mEnter the number of the database you want to Drop (0 to Back to main menu): \e[0m' choice
    #from 0 to i+1, 0 for Back i+1 for all
    if [[ $choice =~ ^[0-$((i+1))]$ ]]; then
        if [ $choice -eq 0 ]; then
            exec "$PWD/main.sh"
        # not i+1 
        elif [ $choice -le $i ]; then
            name="${options[choice-1]}"
            # -r for non empty d
            rm -r "./DataBases/$name"
            echo -e "\e[1;32mRemove DataBase \"$name\"\e[0m"
            exec "$PWD/main.sh"
        else
            #delete all i+1
            rm -r "./DataBases"/*
            echo -e "\e[1;32mAll Databases removed\e[0m"
            exec "$PWD/main.sh"
        fi
    else
        echo -e "\e[1;31mError: Invalid choice. Please enter a valid number.\e[0m"
        exec "$PWD/Drop_DB.sh"
    fi
fi

