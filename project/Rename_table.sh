
#!/bin/bash
echo -e "\e[93m-----Rename The Table-----\e[0m"

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

read -p " Enter New name of Table : " name  
name=$(echo $name | tr ' ' '_') 
regex="^[A-Za-Z][A-Za-z0-9_]*$"
            
if [[ $name =~ $regex ]] ;then 
    if [[ -e ./$name ]] ;then 
        echo -e "\e[1;31m$name Table Already Exist Please try agin\e[0m"
        continue;
    else
        mv ./$table_name ./$name 
        echo -e "\e[1;32mSuccess Rename Table $table_name to $name  \e[0m "

    fi
else 
    echo -e "\e[1;31mError: Input invalid. Please try again.\e[0m"
    continue;

fi

cd ..
cd ..
exec "$PWD/Connect_DB.sh"