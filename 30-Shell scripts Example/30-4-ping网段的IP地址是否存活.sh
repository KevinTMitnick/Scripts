#!/bin/bash

. /etc/inti.d/functions

#for i in 10.0.0{1..254}
#do
#    ping -c 1 -W 1 $i &>/dev/null
#    if [ $? -eq 0 ];then
#        action "$i" /bin/true
#    else
#        action "$i" /bin/false
#    fi
#done

CMD="ping -c 1 -W 1"
IP="10.0.0."
IPList="/tmp/iplist.txt"
for i in `seq 254`
do
    {  
    $CMD $IP$i &>/dev/null
    if [ $? -eq 0 ];then
        action "$IP$i" /bin/true
        echo $i >>$IPList
    else
        action "$IP$i" /bin/false
    fi
    }&
done
