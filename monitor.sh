#!/bin/bash
#linux服务器监控
#set -x
2012-02-25
#version: 2.0
export LC_ALL="en_US.UTF-8"
 
server_info(){
echo ====================================================
#echo ======Time======
#date
echo ======1 hostname======
/bin/hostname
echo ======2 IP MASK======
/sbin/ifconfig eth0|grep "inet addr:"|awk '{print $2,"/ "$4}'
echo ======3 Gateway======
cat /etc/sysconfig/network|grep GATEWAY|awk -F "=" '{print $2}'
echo ======4 Product Name======
dmidecode | grep -A10 "System Information$" |grep "Product Name:"|awk '{print $3,$4,$5}'
##echo ======Host SN======
##dmidecode | grep -A10 "System Information$" |grep "Serial Number:"|awk '{print "SN:",$3}'
echo ======5 CPU ======
cat /proc/cpuinfo|grep "name"|cut -d: -f2 |awk '{print "*"$1,$2,$3,$4}'|uniq -c
echo ======6 Physical memory number======
 dmidecode | grep -A 16 "Memory Device$" |grep Size:|grep -v "No Module Installed"|awk '{print "*" $2,$3}'|uniq -c
echo ======7 System version ======
cat /etc/issue | head -1
echo =========================================================
}
 
OS_info(){
echo ==========================================================
echo ======1 kernel version ======
uname -a
echo ======2 running day ======
/usr/bin/uptime |awk '{print $3,$4}'
echo ==========================================================
}
 
performance_info(){
echo ==========================================================
echo ======1 CPU used ======
top -n 1 |grep C[Pp][Uu] |grep id|awk '{print $5}'|awk -F "%" '{print $1}'
#cpu_total=$(cat /proc/stat | grep 'cpu ' | awk '{print $2+$3+$4+$5+$6+$7+$8}')
#cpu_idle=$(cat /proc/stat | grep 'cpu ' |awk '{print $5}')
#cpu_use=`expr 100-"$cpu_idle/$cpu_total*100"|bc -l`
#echo $cpu_total
#echo $cpu_idle
#echo $cpu_use
echo ======2 memory used ======
#free -m |grep Mem|awk '{print $2,$3}'
mem_total=$(free -m |grep Mem|awk '{print $2}')
mem_used=$(free -m |grep Mem|awk '{print $3}')
mem_rate=`expr $mem_used/$mem_total*100|bc -l`
echo $mem_rate
echo ======3 swap used ======
#free -m |grep Swap|awk '{print $2,$3}'
Swap_total=$(free -m |grep Swap|awk '{print $2}')
Swap_used=$(free -m |grep Swap|awk '{print $3}')
Swap_rate=`expr $Swap_used/$Swap_total*100|bc -l`
echo $Swap_rate
echo ======4 top pic ======
top -b -n 1|head -25
echo ==========================================================
}
 
sec_info(){
echo ======1 user load ======
w
echo ======2 file used ======
df -ah
echo ======3 demsg error======
dmesg |grep fail
dmesg |grep error
echo ======4 demsg error======
lastlog
}

system_hardware_config(){
echo ===========================disk====================================
df -H |awk "{OFS=\"\t\"}{ print \$1,\$2,\$3,\$4,\$5,\$6}"
echo ===========================free====================================
free |head -1 |awk "{OFS=\"\t\"} {print \$1,\$2,\$6}"
free -m |awk "BEGIN{OFS=\"\t\"}{if (NR==2 ||NR==4 )print \$2,\$3,\$7}"
}
 
server_info>>$(/bin/hostname)-`date +%F`
OS_info>>$(/bin/hostname)-`date +%F`
performance_info>>$(/bin/hostname)-`date +%F`
sec_info>>$(/bin/hostname)-`date +%F`
echo "run Ok"

######################这是脚本内容结束部分######################################
