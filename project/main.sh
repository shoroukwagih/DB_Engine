#!/bin/bash
printf "\n-------Welcome To Our Database System-------\n\n"

DataBases="./DataBases"

if [ -d "$DataBases" ]; then
    printf "\n---YOu already have a DataBases Directory---\n\n"
    
else
    printf "\n--DataBases Directory has been created--\n\n"
    mkdir -p DataBases
    
fi


PS3=$'\e[1;35mPlease select an option:\e[0m '


options=("Create DataBase" "List DataBase" "Drop DataBase" "Rename DB" "Connect DataBase" "Exit the program")

select choice in "${options[@]}"; do
    case $REPLY in
    1)
        
        source ./Create_DB.sh
        ;;
    2)
        
        source ./List_DB.sh
        ;;
    3)
        source ./Drop_DB.sh
        ;;
    4)
        source ./Rename_DB.sh
        ;;
    5)

        source ./Connect_DB.sh
        ;;
    6)
        echo "Exiting the program"
        exit
        ;;
    *)
        echo "----Invalid option. Please try again.----"
        continue
        ;;
    esac
    break
done

