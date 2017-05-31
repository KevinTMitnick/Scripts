#!/bin/bash

logFile=/root/access.log

# 取出封禁的IP
Ip=`awk '{a[$1]++}END{for(i in a)if(a[i]>0){print i}}' $logFile`
# Ip=`netstat -an|awk '{a[$1]++}END{for(i in a)if(a[i]>0){print i}}'`

# for循环IP，一个一个判断是否已经封禁，如果没有，就添加规则。
for i in $Ip
  do
    if [ `iptables -L -n|grep $i|wc -l` -eq 0  ];then
       iptables -I INPUT -s $i -j DROP
    fi
done

