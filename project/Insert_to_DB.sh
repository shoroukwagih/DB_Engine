#!/bin/bash

echo -e "\e[93m-----Insert Data into Table-----\e[0m"

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

regex_string="^[A-Za-z].*$"
regex_num="^[0-9]+$"
column_names=$(sed -n 1p ./$table_name)
column_types=$(sed -n 2p ./$table_name)
# seperate
IFS=':' read -ra col_names_arr <<< "$column_names"
IFS=':' read -ra col_types_arr <<< "$column_types"

while true; do
    read -p "Enter the number of rows to insert: " num_rows
    if [[ $num_rows =~ $regex_num && $num_rows -gt 0 ]]; then
        break
    else
        echo -e "\e[1;31mError: Please enter a valid positive integer.\e[0m"
    fi
done

for ((row = 1; row <= num_rows; row++)); do
    data_values=()

    for ((i = 0; i < ${#col_names_arr[@]}; i++)); do
        col_name=${col_names_arr[$i]}
        col_type=${col_types_arr[$i]}

        if [[ $i -eq 0 ]]; then
            col_type="Integer"
            echo -e "\e[0;33mPrimary Key: $col_name\e[0m"

            while true; do
                read -p "Enter value for $col_name ($col_type) for row $row: " value

                if [[ $value =~ $regex_num && -n $value ]]; then
                    primary_key_exists=$(awk -F: -v val="$value" '$1 == val {count++} END{print count}' "./$table_name")

                    if [[ $primary_key_exists -eq 0 ]]; then
                        data_values+=("$value : ")
                        break
                    else
                        echo -e "\e[1;31mError: Value '$value' is not unique. Please try again.\e[0m"
                    fi
                else
                    echo -e "\e[1;31mError: Value must be a non-empty integer.\e[0m"
                fi
            done
        else
            while true; do
                read -p "Enter value for $col_name ($col_type) for row $row: " value
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
        fi
    done

    echo "${data_values[*]}" >> ./$table_name
done

echo -e "\e[1;32mData inserted into $table_name\e[0m"

cd ..
cd ..
exec "$PWD/Connect_DB.sh"
