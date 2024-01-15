#!/bin/bash

echo -e "\e[38;5;208mSelect Data from Table\e[0m"

available_tables=$(ls -p | grep -v /)

if [[ -z "$available_tables" ]]; then
    echo -e "\e[1;31mError: No tables found. Please create a table first.\e[0m"
    cd ..
    cd ..
    exec "$PWD/Connect_DB.sh" 
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

options=("Select one row" "Select all rows")

select choice in "${options[@]}"; do
    case $REPLY in
        1)
            while true; do
                read -p "Enter the value of the primary key to be selected: " value
                if [[ $value =~ $regex_num ]]; then
                    if [[ -n $value ]]; then
                        primary_key_exists=$(awk -F: -v val="$value" '$1 == val {count++} END{print count}' "./$table_name")

                        if [[ $primary_key_exists -eq 0 ]]; then
                            echo -e "\e[1;31mThe Value '$value' is not found. Please try again.\e[0m"
                            continue
                        else
                        
                            echo -e "\e[1;32mThe row with the primary key $value in table $table_name will be selected.\e[0m"
                           cut -d',' -f3 "./$table_name" | awk -v val="$value" '$1 == val {print; exit}'
                            
                            cd ..
                            cd ..
                            exec "$PWD/Connect_DB.sh"
                        fi
                    else
                        echo -e "\e[1;31mError: Value cannot be empty. Please try again.\e[0m"
                        continue
                    fi
                else
                    echo -e "\e[1;31mInvalid input. Should be an integer, not a string.\e[0m"
                    continue
                fi
            done
            ;;
        2)
            # Select all rows except the first two rows
            awk -F',' 'NR > 2 {print}' "$table_name"
            cd ..
            cd ..
            exec "$PWD/Connect_DB.sh"
            ;;
        3)
            # Extract column names and store them in the variable column_names
            column_names=$(sed -n 1p "./$table_name")
            
            echo -e "\e[0;33mAvailable Columns:\e[0m"
            awk -F',' '{ for(i=1; i<=NF; i++) { printf "%d) %s\n", i, $i } }' "./$table_name"

            read -p "Enter the column number to be selected: " column_number

            if [[ $column_number =~ ^[0-9]+$ && $column_number -ge 1 && $column_number -le NF ]]; then
                # User input is a valid column number
                awk -F',' -v col_number="$column_number" 'NR > 1 { print $col_number }' "./$table_name"
                cd ..
                cd ..
                exec "$PWD/Connect_DB.sh"
            else
                echo -e "\e[1;31mError: Invalid column number. Please try again.\e[0m"
            fi
            ;;
        *)
            echo "-----Invalid option. Please try again.-----"
            continue
            ;;
    esac
    break
done