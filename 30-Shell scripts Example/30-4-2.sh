#!/bin/bash

. /etc/init.d/functions

ipList=/root/active_iplist
for i in 10.0.0.{1..254}
  do
   ping  -c 1 -W 1 $i &>/dev/null && echo $i >>$ipList  &
done
