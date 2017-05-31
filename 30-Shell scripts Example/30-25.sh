#!/bin/bash
read -p "Please Enter a number:" Line
for ((i=1; i<=$Line; i++))
do
    for ((m=1;m<=$(($Line+1));m++))
    do
        echo -n "*"
    done
    for ((h=1; h<=$(($Line-1)); h++))
    do
        echo -n '*'
    done
    echo
done

