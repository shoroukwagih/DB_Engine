#!/bin/bash


# save d in options with out /
options=($(ls -F "./DataBases" | grep '/' | tr '/' ' '))
if [ ${#options[@]} -eq 0 ]; then
    echo -e "\e[1;31mNo databases to Connect, Create a DataBase first\e[0m"
    exec "$PWD/main.sh"
else
    echo -e "\e[93m-----Select a database to connect:\e[0m"
    for ((i = 0; i < ${#options[@]}; i++)); do  
        echo "$((i+1)) ) ${options[i]}"
    done

    
    read -p $'\e[38;5;208mEnter the number of the database you want to Connect (0 to Back to main menu): \e[0m' choice

    if [[ $choice =~ ^[0-$((i))]$ ]]; then
        if [ $choice -eq 0 ]; then
            source "./main.sh"
        elif [ $choice -le $i ]; then
            name="${options[choice-1]}"
            cd ./DataBases/$name
            echo -e "\e[1;32mSuccess Connect DataBase $name\e[0m "
            PS3=$'\e[1;35mPlease select an option:\e[0m '


            options=("Create Table" "List Table" "Drop Table" "Insert to table" "Select from table" "Update table" "Delete from table" "Rename table" "Back to the main menu" "Exit the program")

            select choice in "${options[@]}"; do
            case $REPLY in
            1)
                
                source ../../Create_table.sh
                ;;
            2)
                
                source ../../List_table.sh
                ;;
            3)
                source ../../Drop_table.sh
                ;;
            4)
                source ../../Insert_to_DB.sh
                ;;
            5)
                source ../../Select_to_DB.sh
                ;;
            6)
                source ../../Update_DB.sh
                ;;
            7)
            
                source ../../Delete_from_DB.sh
                ;;

            8)
                source ../../Rename_table.sh
                ;;


            9)
                cd ..
                cd ..
                exec "$PWD/main.sh"
                ;;
            10)
                echo "Exiting the program"
                exit
                ;;
            *)
                echo "-----Invalid option, Please try again.-----"
                continue
                ;;
                esac
                break
            done

        fi
    else
        echo -e "\e[1;31mError: Invalid choice. Please enter a valid number.\e[0m"
        exec "$PWD/Connect_DB.sh"
    fi
fi
