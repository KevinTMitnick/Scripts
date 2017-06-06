#!/bin/bash


# Defined variables and Judge this file
DbFile=./while_ernie.db
[ ! -f $DbFile ] && touch $DbFile

# Defined color variables
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PINK='\E[1;35m'
RES='\E[0m'

# Defined trapper function
function trapper(){
	trap ':' INT EXIT TSTP TERM HUP
}

# Defined Random function
function random(){
	local x y
	x=$(($RANDOM%9))
	y=$(($RANDOM%9))
	echo $x$y
} 

# Defined warn function
function warn(){
	echo -e "${RED_COLOR}Please enter the correct format name! Like zhangsan!${RES}"
	countdown
	continue
}

function warn2(){
	echo -e "${RED_COLOR}You have entered the name! Give the chance to others!${RES}"
	countdown
	continue
}

# Defined Countdown function
function countdown(){
        for i in `seq -w 10 -1 1`
          do
           echo -ne "\b\b$i";
           sleep 1;
        done
}

# Defined Check Name function
function check_name(){
	echo -e "${YELOW_COLOR}Please enter [exit] to exit the program${RES}" 
	read  -p "Please enter the name of the Pinyin:" name name1
	[ "$name" == "exit" ]&& exit 0
	[ -n "$name1" ] && warn
	[ -n "$name" -a -z "`echo "${name//[a-zA-Z]/}"`" ] || warn
}

# Defined Check File function
function check_file(){
	local Name Id

	# Judge only one name
	Name=`awk '{if($1=="'$name'") print $1}' $DbFile`
	[ -z "$Name" ] || warn2

	# make only one num
	num=`random`
	Id=$num
	while [ -n "$Id" ] 
	  do
	    num=`random`
	    Id=`awk '{if($2=="'$num'") print $2}' $DbFile`
	done

	# write to file
	printf "%-20s %-2s\n" $name $num >> $DbFile
}

# Defined Welcome function
function welcome(){
	clear
	echo -e "${GREEN_COLOR}
	     This program will select 3 students to participate in
	the training of enterprise project practice out of the oldboy.

	The students are eligible to participate in the list as follows${RES}"
	# Print the name of the first three
	echo -e "${BLUE_COLOR}`sort -rn -k2 $DbFile|head -3`${RES}"
}

# Defined main Functions
function main(){
	while true
	  do
	    trapper
	    welcome
	    check_name
	    check_file
	done
}

main

