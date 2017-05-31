#!/bin/bash

logFile=/server/scripts/slave.log
tmpFile=/server/scripts/tmp.log

function Send(){
   echo "Slave_IO_Running:$1 Slave_SQL_Running:$2 Seconds_Behind_Master:$3"  >>$tmpFile
}



function IO(){
  io_status=`awk -F '[ :]+' '/Slave_IO_Running/ {print $3}' $logFile`
  [ "$io_status" == "Yes"  ] ||\
  Flag=1
}


function SQL(){
  sql_status=`awk -F '[ :]+' '/Slave_SQL_Running/ {print $3}' $logFile`
  [ "$sql_status" == "Yes"  ] ||\
  Flag=1
}


function Seconds(){
  sec_status=`awk -F '[ :]+' '/Seconds_Behind_Master/ {print $3}' $logFile`
  [ "$sec_status" == "0"  ] ||\
  Flag=1
}


function main(){
  while true
    do
      Flag=0
      IO
      SQL
      Seconds
      [ $Flag -eq 1 ] && Send $io_status $sql_status $sec_status
      sleep 5
  done
}

main

