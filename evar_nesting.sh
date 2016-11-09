#!/bin/bash
#变量嵌套处理

var1=var2
var2=real

#第一种
echo ${!var1}
temp1=${!var1}
echo $temp1

#第二种
eval temp2=\$$var1
echo $temp2
