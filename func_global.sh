#!/bin/bash
# testing the script
function myfun {
  value=$[ $value * 2 ]
}
read -p "Enter a value:" value
echo "value:$value"
myfun
echo "The new value is:$value"
