#!/bin/bash

DIR="/oldboy"

[ -d $DIR ] || mkdir -p $DIR
cd $DIR

for i in {1..10}
do
    RanChar=`uuidgen |tr '0-9-' 'a-z'|cut -c -10`
    touch ${RanChar}_oldboy.html
done
