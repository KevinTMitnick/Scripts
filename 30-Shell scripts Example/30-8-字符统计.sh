#!/bin/bash

for i in I am oldboy teacher welcome to oldboy trainingclass
do
    if [ ${#i} -le 6 ];then
        echo $i
    fi
done
