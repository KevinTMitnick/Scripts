#!/bin/bash

User=root
Pass=123456
Exclude="Database|schema"
DataList=`mysql -u$User -p$Pass -e "show databases" 2>/dev/null|egrep -v $Exclude`
#echo $dataList
BackDir=/backup/mysql

[ -d $BackDir ] || mkdir -p $BackDir

for i in $DataList
  do
    mysqldump -u$User -p$Pass -F --single-transaction -R -B $i 2>/dev/null|gzip > $BackDir/${i}-$(date +%F).sql.gz
done
