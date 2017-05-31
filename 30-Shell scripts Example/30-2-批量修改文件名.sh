#!/bin/bash
# ...

DIR="/oldboy"

[ -d $DIR ] || exit 1

cd $DIR

for i in `ls *html`
do
    RanChar=`echo $i|cut -c -10`
    mv $i ${RanChar}_oldgirl.HTML
done
