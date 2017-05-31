#!/bin/bash
. /etc/init.d/functions

userDb=/root/userlist

for i in oldboy{10..20}
  do
    passWord=`uuidgen`
    useradd $i  &>/dev/null
    if [ $? -eq 0 ];then
      action "$i" /bin/true
      echo "用户名：$i，密码：$passWord" >> $userDb
      echo $passWord|passwd --stdin $i &>/dev/null
    else
      action "$i" /bin/false
    fi
done
