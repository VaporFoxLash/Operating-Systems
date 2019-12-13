#!/bin/bash
 
if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    echo 'usage: ./shardCollect.sh [-d] [--directory] [CUSTOM_PATH]'
    echo 'to find all subdirectories in a folder'
    exit
fi
   
if [ "$1" == "-d" ] || [ "$1" == "--directory" ]
then
    dir="$2"
else
    dir="$1"
fi
 
if [ -z "$dir" ]
then
    path=$(pwd)
else
    path=$dir
    if [ ! -d "$path" ]
    then
        echo "shardCollect.sh: -d: $path: No such directory"
        exit 1
    fi
fi
 
res=()
pathSize=${#path}
pathSize=$((pathSize + 2))
 
filepath=$(lsof +D "$path" 2> /dev/null | awk '{print $9}' | cut -c ${pathSize}- | cut -d '/' -f1 | sort | uniq)
 
cd "$path" || exit

readarray -t subfolders <<< "$(find . -maxdepth 1 -type d)"
 
for folder in "${subfolders[@]}"
do
    folder_name=${folder:2}
    if [[ ! "${filepath[*]}" =~ ${folder_name} ]]
    then
        res+=("$folder_name")
    fi
done
 
check="false"
for res1 in "${res[@]}"
do
    echo "$res1"
    check="true"
done
 
if [ $check = "true" ]
then
    exit 1
else
    exit
fi
