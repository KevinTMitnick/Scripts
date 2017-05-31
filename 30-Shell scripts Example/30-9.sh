#!/bin/bash

LogFile=/server/scripts/slave.log
# Status=`mysql -uroot  -poldboy123 -e 'show slave status\G'|awk '/Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master/{print $2}'`


while true
  do
    Flag=0
    Status=(`awk '/Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master/{print $2}' $LogFile`)


    for i in `seq ${#Status[*]}`
      do
        if [ "${Status[((i-1))]}" == "Yes" -o "${Status[((i-1))]}" == "0" ];then
          :
      else
          ((Flag++))
        fi
    done
    
    if [ $Flag -ne 0 ] ;then
       echo "Mysql Slave is bad"
       # 只要Flag不等于0我们就可以发邮件，发短信了。
    fi

    sleep 30
done
