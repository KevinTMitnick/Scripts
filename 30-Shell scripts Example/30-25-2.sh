#!/bin/bash
read -p "Please Enter a number:" Line
for ((i=1; i<=$Line; i++))
do
    for ((m=1;m<=$(($Line));m++))
    do
        echo -n "*"
    done
    echo
done

