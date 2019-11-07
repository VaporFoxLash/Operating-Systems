#!/bin/bash

bool=false
clr=":"
IFS=':'
if [ "$1" != "--help" ] && [ "$1" != "-h" ]; then
	for directory in $PATH; do
		if [[ ! -d "$directory" ]]
    	then
        	continue
    	fi
		for file in $directory/*; do
			if [[ -f "$file" && -x "$file" ]]; then
            	#echo "Executable File: " $file
				if [[ ! $clr = *:$directory:* ]]; then   
                	clr="$clr$directory:"
                	break
            	fi	
    		elif [[ -z ${res:1} ]]; then
    			echo "Path does not contain executable files"
			else   
    			echo "${clr:1:-1}"
			fi
		done
	done
fi
#PATH=$(echo $PATH | awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')
