#!/bin/bash

logFile=/server/scripts/slave.log

while true
  do
    Flag=0
    Status=`awk '/Slave_IO_Running|Slave_SQL_Running|Seconds_Behind_Master/{print $2}' $logFile`


    if [ "`echo $Status`" == "Yes Yes 0"  ] ;then
      :
    else
      echo "MySQL Slave is bad "
    fi

    sleep 3
done
