#!/bin/bash

echo -e "\e[93m-----Rename DataBase-----\e[0m"

# save d in options with out /
options=($(ls -F "./DataBases" | grep '/' | tr '/' ' '))
if [ ${#options[@]} -eq 0 ]; then
    echo -e "\e[1;31mNo databases to Rename, Create a DataBase first\e[0m"
    exec "$PWD/Rename_DB.sh"
else
    echo -e "\e[93m-----Select a database to Rename:\e[0m"
    for ((i = 0; i < ${#options[@]}; i++)); do  
        echo "$((i+1)) ) ${options[i]}"
    done

    
    read -p $'\e[38;5;208mEnter the number of the database you want to Rename (0 to Back to Rename_DB menu): \e[0m' choice

    if [[ $choice =~ ^[0-$((i))]$ ]]; then
        if [ $choice -eq 0 ]; then
            source "./Rename_DB.sh"
        elif [ $choice -le $i ]; then
            name="${options[choice-1]}"
            read -p " ----Enter New name of DB : " new_name  
            new_name=$(echo $new_name | tr ' ' '_') 
            regex="^[A-Za-Z][A-Za-z0-9_]*$"
         if [[ $new_name =~ $regex ]] ;then 
           if [[ -d ./DataBases/$new_name ]] ;then 
                   echo -e "\e[1;31mDB name didn't changed , please try agin\e[0m"
                   continue
            else
                 mv ./DataBases/$name ./DataBases/$new_name 
                 echo -e "\e[1;32mSuccess Rename Database $name to $new_name\e[0m"
                 exec "$PWD/main.sh"
            fi
         else 
             echo -e "\e[1;31mError: Input invalid. The name must start with character\e[0m"
            continue;

         fi



        fi
    else
        echo -e "\e[1;31mError: Invalid choice. Please enter a valid number.\e[0m"
        exec "$PWD/Rename_DB.sh"
    fi
fi
