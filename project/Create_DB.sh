echo -e "\e[93m-----Create DataBase-----\e[0m"
read -p " ----Enter name of DB : " name  
name=$(echo $name | tr ' ' '_') 
regex="^[A-Za-Z][A-Za-z0-9_]*$"
            
if [[ $name =~ $regex ]] ;then 
    if [[ -d ./DataBases/$name ]] ;then 
        echo -e "\e[1;31mDB Already Exist\e[0m"
        continue;
    else
        mkdir ./DataBases/$name 
        echo -e "\e[1;32m$name DB Created\e[0m"
        exec "$PWD/main.sh"


    fi
else 
    echo -e "\e[1;31mError: Input invalid. The name must start with character\e[0m"
    exec  "$PWD/Create_DB.sh"   

fi

exec "$PWD/Create_DB.sh"
