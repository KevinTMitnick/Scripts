#!/bin/bash
poFile=/tmp/pojie.txt
dict=/tmp/md5db


for i in `cat $poFile`
  do
    grep --color $i $dict
done
