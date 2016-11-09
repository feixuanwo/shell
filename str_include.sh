#!/bin/bash
#判断字符串包含的处理
str="this is a test"

[[ $str =~ "this" ]] && echo "this is part of \$str"
[[ $str =~ "that" ]] || echo "that is not part of \$str"
