#!/bin/bash


echo -e "\e[38;5;208mDelete Data into Table\e[0m"

available_tables=$(ls -p | grep -v /)

if [[ -z "$available_tables" ]]; then
    echo -e "\e[1;31mError: No tables found. Please create a table first.\e[0m"
    cd ..
    cd ..
    exec "$PWD/Insert_to_DB.sh" 
fi

echo -e "\e[0;33mAvailable Tables:\e[0m"
select table_name in $available_tables; do
    if [[ -n "$table_name" ]]; then
        break
    else
        echo -e "\e[1;31mError: Invalid selection. Please try again.\e[0m"
    fi
done

column_names=$(sed -n 1p ./$table_name)
column_types=$(sed -n 2p ./$table_name)
regex_num="^[0-9]+$"

 

options=("Remove one row" "Remove all")

    select choice in "${options[@]}"; do
        case $REPLY in
        1)
            while true; do
                read -p "Enter value of primary key to deleted: " value


                if [[ $value =~ $regex_num ]] ;then
                if [[ -n $value ]]; then
                    primary_key_exists=$(awk -F: -v val="$value" '$1 == val {count++} END{print count}' "./$table_name")

                if [[ $primary_key_exists -eq 0 ]]; then
                    echo -e "\e[1;31mThe Value '$value' is not found . Please try again.\e[0m"
                    continue
                else
                    awk -F: -v val="$value" 'BEGIN{found=0} $1==val && found==0 {found=1; next} {print}' "$table_name" > "$table_name.tmp" && mv "$table_name.tmp" "$table_name"
                    echo -e "\e[1;32mSuccess Delete row of primary key is $value in table $table_name \e[0m "
                    cd ..
                    cd ..
                    exec "$PWD/Connect_DB.sh"
                fi

                else
                    echo -e "\e[1;31mError: Value cannot be empty. Please try again.\e[0m"
                    continue;
                fi   
                else
                    echo -e "\e[1;31mInvalid input. Should be an integer, not a string.\e[0m"      
                    continue
                fi
            done
        ;;
    2)
        
        > "$table_name"
        echo $column_names >> $table_name
        echo $column_types >> $table_name
        echo 
        echo -e "\e[1;32mSuccess! Removed all rows from table $table_name\e[0m"
        cd ..
        cd ..
        exec "$PWD/Connect_DB.sh"
        ;;
    
    *)
        echo "-----Invalid option, Please try again.-----"
        continue
        ;;
        esac
        break
    done