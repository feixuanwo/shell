#!/bin/bash

set -x
function myfun {
	local value=$[ $value * 2 ] 
	echo "local value:"$value
}
set +x
read -p "Enter a value:" value
myfun
echo "The new value is $value"
