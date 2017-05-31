#!/bin/bash
. /etc/init.d/functions
#array=(
#http://www.etiantian.org
#http://www.taobao.com
#http://oldboy.blog.51cto.com
#http://10.0.0.7
#)

urlList=/server/scripts/url.txt
array=(`cat $urlList`)
function Check_Url(){
  curl -o /dev/null  -s  $1 -w "%{http_code}\n" &>/dev/null  && return 0||return 1
}
 
function main(){
  while true
    do
      for i in ${array[*]}
        do
          Check_Url $i
          if [ $? -eq 0 ]
	    then
              action "$i" /bin/true
          else
              action "$i" /bin/false
          fi
      done
      sleep 10
  done
}
  
main

