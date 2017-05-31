#!/bin/bash

User=root
Pass=123456
Exclude="Database|schema"
DataList=`mysql -u$User -p$Pass -e "show databases" 2>/dev/null|egrep -v $Exclude`
BackDir=/backup/mysql

[ -d $BackDir ] || mkdir -p $BackDir

for i in $DataList
  do
    tableList=`mysql -u$User -p$Pass -e "use $i;show tables;" 2>/dev/null|grep -v 'Tables'`
    tableDir=$BackDir/$i
    [ -d $tableDir ] || mkdir -p $tableDir

    for t in $tableList
      do
         mysqldump -u$User -p$Pass -F --single-transaction -R  $i $t 2>/dev/null|gzip > $tableDir/${t}-$(date +%F).sql.gz
    done
done
