#!/bin/bash
# testing the script
function myfun {
  local value=$[ $value * 2 ]
  echo $value
}
read -p "Enter a value:" value
result=`myfun`
echo "The new value is:$value"
echo "The result of the fun is $result"
