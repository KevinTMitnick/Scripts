#!/bin/bash

userDb=/root/userlist

for i in oldboy{01..10}
  do
    useradd $i
    passWord=`uuidgen`
    echo $passWord|passwd --stdin $i
    echo "用户名：$i，密码：$passWord" >> $userDb
done
