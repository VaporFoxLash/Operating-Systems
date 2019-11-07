#!/bin/bash

clr=":"
IFS=':'
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	echo "Run clearPath.sh or enter any directory to clear path"
else
	for directory in $PATH; do
		if [[ ! -d "$directory" ]]
    	then
        	continue
    	fi
		for file in "$directory"/*
		do
			if [[ -f "$file" && -x "$file" ]]; then
            	#echo "Executable File: " $file
				if [[ ! $clr = *:$directory:* ]]; then   
                	clr="$clr$directory:"
                	break
            	fi	
    		elif [[ -z ${clr:1} ]]
    		then
    			echo "Path does not contain executable files"
			else   
    			echo "${clr:1:-1}"
			fi
		done
	done
fi
