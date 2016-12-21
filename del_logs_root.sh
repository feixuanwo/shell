#!/bin/bash

#author:zhangyong
#date:20151216
#description:删除指定日志
#location:ansible所在服务器/root/shell/.use下
#document:暂无

. ~/.bash_profile

#常量
CONFIG_NAME=del_logs.ini                    #配置文件名
CONFIG_PATH=/root/shell/normal/.use/.etc/   #配置文件目录
LOG_NAME=del_logs.log                       #日志文件名
LOG_PATH=/root/shell/normal/.use/.log/      #日志文件目录
SHELL_PATH=/root/shell/normal/.use/.shell/  #脚本所在路径
LOCK_NAME=.del_logs.lock                    #锁文件名

#变量
user=               #待删除日志的服务器用户名
ip=                 #待删除日志的服务器IP
reserve_days=       #日志保留天数
format=             #日志格式
log_location=       #待删除日志未知
date_discard=       #需要被删除的日志日期

#函数
#打印指定格式日志
log()
{
    log_level=$1                        #第一个参数为数字，确定日志等级
    log_content=$2                      #第二个参数为日志内容
    log_levels=("INFO" "WARN" "ERROR")  #日志一共有3个等级
    echo "`date +%Y-%m-%d" "%H:%M:%S` [${log_levels[$log_level]}]:$log_content" >> ${LOG_PATH}$LOG_NAME
}

#加锁函数
getLock()
{
    touch ${SHELL_PATH}${LOCK_NAME}
}

#解锁函数
releaseLock()
{
    rm ${SHELL_PATH}${LOCK_NAME}
}



#检查配置文件，日志目录
[ -f ${CONFIG_PATH}$CONFIG_NAME ] || { log 2 "No config file,please check ${CONFIG_PATH}$CONFIG_NAME."; exit 1; }
[ -d $LOG_PATH ] || { log 2 "No log dir,please check $LOG_PATH."; exit 2; }

#判断脚本是否已被加锁
if [ -f ${SHELL_PATH}${LOCK_NAME} ] ; then
    log 1 "This shell has been locked"
    exit 1
else
    getLock
fi

#读取配置文件
sed '1d' ${CONFIG_PATH}$CONFIG_NAME|grep -v "^#"|while read line
do
    #得到各个变量
    user=`echo $line|awk '{print $1}'`
    ip=`echo $line|awk '{print $2}'`    
    reserve_days=`echo $line|awk '{print $3}'`
    log_location=`echo $line|awk '{print $4}'`
    #转换格式形式
    format=`echo $line|awk '{print $5}'`
    format=`echo $format|tr -t [a-z] [A-Z]`
    format=${format//YYYY/%Y}
    format=${format//MM/%m}
    format=${format//DD/%d}
    #确定待删除日期及格式
    date_discard=`date -d "-$reserve_days days" +$format`
    log 0 "user:$user ip:$ip reserve_days:$reserve_days log_location:$log_location format:$format date_discard:$date_discard"
    #调用ansible进行日志删除操作
    if [[ $log_location != "/home/$user/.trash" ]] ; then
        #删除用户log(s)目录下的日志
        log 0 "cd $log_location;find . -type f -name \\"*$date_discard*\\" -exec rm {} \;"
        cd $log_location
        find . -type f -name "*$date_discard*" -exec rm {} \;
    else
        #删除用户回收站中的文件
        log 0 "cd $log_location;find . -maxdepth 1 -not -name \".\" -ctime +$reserve_days -exec /bin/rm -rf {} \;" 
        cd $log_location
        find . -maxdepth 1 -not -name "." -ctime +$reserve_days -exec /bin/rm -rf {} \;
    fi
done

#释放锁
releaseLock

log 0 "Delete Over"
