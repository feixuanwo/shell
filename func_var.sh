#!/bin/bash
# testing the script
set -x
function addem {
  if [ $# -eq 0 ]||[ $# -gt 2 ]
  then
    echo -1
  elif [ $# -eq 1 ]
  then
    echo $[ $1 + $1 ]
  else
    echo $[ $1 + $2 ]
  fi
}

echo -n "Adding 10 and 15:"
value=`addem 10 15`
echo $value
echo -n "Just one number 10:"
value=`addem 10`
echo $value
echo -n "No numbers:"
value=`addem`
echo $value
echo -n "More than two numbers:"
vaule=`addem 10 15 20`
echo $value
