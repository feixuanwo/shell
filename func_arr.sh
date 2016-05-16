#!/bin/bash
# testing the script
function addarray {
    local sum=0
    local newarray
    newarray=(`echo "$@"`) #获取参数列表
    for value in ${newarray[*]}
    do
      sum=$[ $sum + $value ]
    done
    echo $sum
}

myarray=(1 2 3 4 5)
echo "The original array is :${myarray[*]}"
arg=`echo ${myarray[*]}`
#addarray $arg
result=`addarray $arg`
echo "The result is $result"

echo "============"
myarr=(1 2 3 4 5)
echo ${myarr[*]}
echo ${myarr[@]}
echo "下标为1的值:"${myarr[1]}
myarr[1]=100
echo "新数组:"${myarr[*]}

#下标不存在的情况
myarr[5]=100
echo "新数组:"${myarr[*]}

unset myarr
echo "新数组:"${myarr[*]}

#切片
myarr=(1 2 3 4 5)
echo ${myarr[@]:1:4}
echo ${myarr[*]:0:3}
echo ${myarr[@]}
temparr=${myarr[@]:1:4}
echo "temparr:"${temparr[*]}
echo "数组temparr元素个数:" ${#temparr[@]}
len=${#temparr}
echo "len:" $len

echo "111111111111111111"
#替换
echo ${myarr[@]/3/100}
echo ${myarr[@]/1/100}
echo ${myarr[@]}

echo "111111111111111111"
myarr1=(1 2 3 4 5)
echo "myarr1元素个数:" ${#myarr1[@]}
echo "len:" ${#myarr1}
