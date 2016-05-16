#!/bin/bash
# testing the script
function myfun {
  read -p "Enter a value:" value
  echo "double the value"
  return $[ $value * 2 ]
}

myfun

echo "The new vlue is $?"
