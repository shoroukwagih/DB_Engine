echo -e "\e[93m-----Create Table-----\e[0m"
read -p " Enter name of Table : " name  
name=$(echo $name | tr ' ' '_') 
regex="^[A-Za-Z][A-Za-z0-9_]*$"
            
if [[ $name =~ $regex ]] ;then 
    if [[ -e ./$name ]] ;then 
        echo -e "\e[1;31m$name Table Already Exist Please try agin\e[0m"
        continue;
    else
        touch ./$name 
        echo -e "\e[1;32m$name Table Created\e[0m "

    fi
else 
    echo -e "\e[1;31mError: Input invalid. Please try again.\e[0m"
    continue;

fi
#............................................
num_regex="^[1-9][0-9]*$"

while ! [[ $num =~ $num_regex ]]; do
    read -p "Enter number of columns in the table $name: " num

    if ! [[ $num =~ $num_regex ]]; then 
        echo -e "\e[1;31mError: Input invalid. Please enter a valid positive integer.\e[0m"
    fi
done

echo "Your column number of the table is $num"

#.................................
#metadata
num_col=$num
entered_columns=()

echo -e "\033[0;33m---Insert metadata for table $name---\033[0m"

for((i=1;i<=num_col;i++)) do
    if [[ $i -eq 1 ]] ; then
        read -p "Enter name of column num $i is primary key : " col_name

    else
        read -p "Enter name of column num $i : " col_name
    fi
    col_name=$(echo $col_name | tr ' ' '_') 



    if [[ $col_name =~ $regex ]] ;then 
        #enter the column name to the array and if it exist
        if [[ " ${entered_columns[@]} " =~ " ${col_name} " ]]; then
            echo -e "\e[1;31mError: Column name '$col_name' already entered. Please choose a different name.\e[0m"
            i=$i-1
            continue
        else
            entered_columns+=("$col_name") 
            row_name+=$col_name:
            echo -e "\e[35mPlease Select Data Type of $col_name\e[0m"
        if [[ $i -eq 1 ]] ; then
            options=("Integer");
            select choice in "${options[@]}"; do
            case $REPLY in
            1)
            row_type+=Integer:
            ;;
       
        *)
            echo "Invalid option. Please try again."
            continue
            ;;
        esac
        break
    done
        else
            options=( "Integer" "String");
            select choice in "${options[@]}"; do
        case $REPLY in
        1)
            row_type+=Integer:
            ;;
       
           
        2)
            row_type+=String:
            ;;
            
           
        *)
            echo "Invalid option. Please try again."
            continue
            ;;
        esac
        break
    done
    fi

fi

        
        
  
else 
    echo -e "\e[1;31mError: Input invalid. Please try again.\e[0m"
    i=$i-1
    continue;

fi


done
echo $row_name >> $name
echo $row_type >> $name

cd ..
cd .. 
exec "$PWD/Connect_DB.sh"