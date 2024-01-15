#!/bin/bash

echo -e "\e[93m-----Update Data in Table-----\e[0m"

available_tables=$(ls -p | grep -v /)

if [[ -z "$available_tables" ]]; then
    echo -e "\e[1;31mError: No tables found. Please create a table first.\e[0m"
    cd ..
    cd ..
    exec "$PWD/Connect_DB.sh"
fi

echo -e "\e[0;33m---Available Tables:\e[0m"
select table_name in $available_tables; do
    if [[ -n "$table_name" ]]; then
        break
    else
        echo -e "\e[1;31mError: Invalid selection. Please try again.\e[0m"
    fi
done

column_names=$(sed -n 1p ./$table_name)
column_types=$(sed -n 2p ./$table_name)
# separate
IFS=':' read -ra col_names_arr <<< "$column_names"
IFS=':' read -ra col_types_arr <<< "$column_types"

regex_num="^[0-9]+$"
regex_string="^[A-Za-z].*$"

while true; do
    read -p "Enter the primary key value for the row to update: " primary_key

    if [[ $primary_key =~ $regex_num && -n $primary_key ]]; then
        primary_key_exists=$(awk -F: -v val="$primary_key" 'NR>2 && $1 == val {count++} END{print count}' "./$table_name")

        if [[ $primary_key_exists -eq 1 ]]; then
            break
        else
            echo -e "\e[1;31mError: Primary key not found. Please try again.\e[0m"
        fi
    else
        echo -e "\e[1;31mError: Primary key must be a non-empty integer.\e[0m"
    fi
done

for ((i = 1; i <= num_rows; i++)); do
    row_data=$(awk -F: -v key="$primary_key" 'NR>2 && $1 == key' "./$table_name")

    if [[ -n "$row_data" ]]; then
        break
    fi
done

data_values=()

for ((i = 1; i < ${#col_names_arr[@]}; i++)); do
    col_name=${col_names_arr[$i]}
    col_type=${col_types_arr[$i]}

    while true; do
        read -p "Enter new value for $col_name ($col_type): " value
        value=$(echo "$value" | tr ' ' '_')

        if [[ $col_type == "String" && $value =~ $regex_string && -n $value ]]; then
            data_values+=("$value : ")
            break
        elif [[ $col_type == "Integer" && $value =~ $regex_num && -n $value ]]; then
            data_values+=("$value : ")
            break
        else
            echo -e "\e[1;31mError: Invalid input. Please try again.\e[0m"
        fi
    done
done

# Update the row with new values
awk -v key="$primary_key" -v new_data="${data_values[*]}" -F: 'NR>2 && $1 == key {$0 = key" : "new_data} 1' "./$table_name" >temp_file && mv temp_file ./$table_name

echo -e "\e[1;32mData updated in $table_name\e[0m"

cd ..
cd ..
exec "$PWD/Connect_DB.sh"
