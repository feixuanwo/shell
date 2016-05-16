#!/bin/sh

#while read i;do echo "$i $RANDOM";done<nums.txt|sort -k2n|cut -d" " -f1

cat nums.txt | while read i; do echo "$i $RANDOM"; done| sort -k2n | cut -d" " -f1> aaa.txt

i=1
cat aaa.txt | while read line
do
    echo "$line $i"
    i=$[i + 1]
done
