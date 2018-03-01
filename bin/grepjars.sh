#!/bin/bash

PATTERN=$1
DIR=$2

echo "Searching for $PATTERN in $DIR directory"

for j in `ls $DIR`; do
 file_path=$DIR/$j
 match_text=`jar tvf $file_path 2>/dev/null | grep $PATTERN`
 match_result=$?
 if [ "$match_result" == "0" ]; then
   echo "== Match found in $file_path"
   echo "$match_text"
 fi
done
