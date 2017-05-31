#!/bin/bash

LogFile="/root/access.log"

#取出需要封禁的IP地址
IP=`awk '{a[$1]++}END{for(i in a)if(a[i]>2){print i,a[i]}}' $LogFile`
# IP=`netstat -an|awk '{a[$1]++}END{for(i in a)if(a[i]>0){print i}}'`

#for循环先判断是否已经封禁，否则就添加Iptables规则
for i in $IP
do
    if [ `iptables -L -n|grep $i|wc -l` -eq 0 ];then
        iptables -I INPUT -s $i -j DROP
    fi
done
