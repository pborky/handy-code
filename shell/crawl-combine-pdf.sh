#!/bin/bash

if [ -z $2  -o  -z $1 ]; then 
	echo "Usage: $basename <URL> <target>"
	exit 1; 
fi

for line in $(curl "$1"); do 
	url=$(expr "$line" : '.*[hH][rR][eE][fF]\s*=\s*"\([^"]*pdf\)".*');
	if [ -n "$url" ]; then 
		wget $url; 
	fi;  
done

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$2" $(ls *pdf)
