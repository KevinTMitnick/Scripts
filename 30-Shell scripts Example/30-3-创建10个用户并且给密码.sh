#!/bin/bash
. /etc/init.d/functions

USERDB="/tmp/userlist"

for i in oldboy{01..10}
do
    PASS=`uuidgen`
    useradd $i &>/dev/null
    if [ $? -eq 0 ];then
        action "$i" /bin/true
        echo "用户名:$i,密码:$PASS" >>$USERDB
        echo $PASS|passwd --stdin $i &>/dev/null
    else
        action "$i" /bin/false
    fi
done
