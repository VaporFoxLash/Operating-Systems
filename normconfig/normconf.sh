#!/bin/bash

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
	echo "Usage: ./normconf/sh [FILE]..."
  echo "to config date and time"
  echo "-------------------------------------"
  echo "  [$0] INPUT"
  echo "Examples:"
  echo "  ./normconf.sh simple_text.txt"
  echo "  saves a new text file with configured time and/or date"
  exit 1
fi

if [ ! -f "$1" ] ; then
  echo "$0: $1: No such file or directory"
  exit 1
fi

n=$(awk -F "=" '{print $1}' "$1")
v=$(awk -F "=" '{print $2}' "$1")

name=($n)
value=($v)
index=0
result=""
for nam in ${name[@]}
do
	temp_val=${value[$index]}
	for ((j=0;j<${#temp_val};j++))
	do
		s=${temp_val:0:$((j+1))}
		if [[ $s =~ ^-?[0-9]+$ ]] ; then
			va=$s
		fi
	done
	length=${#va}
	len=$((${#temp_val}-length))
	units=${temp_val:$length:$len}
	if [ "$units" == "min" ] ; then
		va=$((va*60))
	fi
	case "$units" in
	"h")
		va=$((va*60*60))
		;;
	"d")
		va=$((va*60*60*24))
		;;
	# "h " && "s"
	# 	va=$((va*60*60))
	#
	# 	;;
	"mm")
		#An arbitrary precision calculator
		a=$(bc <<< $va*0.001)
		if [ "${va:0:1}"  == "." ] ; then
			va="0$va"
		fi
		;;
	"sm")
		va=$(bc <<< $va*0.01)
		if [ "${va:0:1}"  == "." ] ; then
			va="0$va"
		fi
		;;
	"dm")
		a=$(bc <<< $va*0.1)
		if [ "${va:0:1}"  == "." ] ; then
			va="0$va"
		fi
		;;
	"km")
		va=$((va*1000))
		;;
	"mg")
		va=$(va <<< $va*0.000001)
		if [ "${va:0:1}"  == "." ] ; then
			va="0$va"
		fi
		;;
	"g")
		va=$(bc <<< $va*0.001)
	if [ "${va:0:1}"  == "." ] ; then
		a="0$va"
		fi
		;;
	"t")
		va=$((va*1000))
		;;
	esac
	result+="$nam=$va\n"
	index=$((index+1))
done

printf $result > normalizedConfig.txt
echo "New config file with results is saved as: normalizedConfig.txt"
