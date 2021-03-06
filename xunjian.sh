#!/bin/bash

#set -x
#version: 2.0
#export LC_ALL="en_US.UTF-8"
source ~/.bash_profile
echo "=======================================XinXiangInfo====================================================" >>/root/shell/normal/.use/.log/$(/bin/hostname)-`date +%F`
 
server_info(){
echo ===============server_info============================
#echo ======Time======
#date
echo ======1 hostname======
/bin/hostname
echo ======2 IP MASK======
/sbin/ifconfig bond0|grep "inet addr:"|awk '{print $2,"/ "$4}'
echo ======3 Gateway======
#cat /etc/sysconfig/network|grep GATEWAY|awk -F "=" '{print $2}'
#cat /etc/sysconfig/network-scripts/ifcfg-eth0| grep GATEWAY
cat /etc/sysconfig/network-scripts/ifcfg-bond0| grep GATEWAY|awk -F "=" '{print $2}'
#echo ======4 Product Name======
#dmidecode | grep -A10 "System Information$" |grep "Product Name:"|awk '{print $3,$4,$5}'
##echo ======Host SN======
##dmidecode | grep -A10 "System Information$" |grep "Serial Number:"|awk '{print "SN:",$3}'
echo ======4 CPU ============
cat /proc/cpuinfo|grep "name"|cut -d: -f2 |awk '{print "*"$1,$2,$3,$4}'|uniq -c
echo ======5 Physical memory number======
/usr/sbin/dmidecode | grep -A 16 "Memory Device$" |grep Size:|grep -v "No Module Installed"|awk '{print "*" $2,$3}'|uniq -c
echo ======6 System version ========
cat /etc/issue | head -1
}
 
OS_info(){
echo ===============OS_info================================
echo ======1 kernel version ======
uname -a
echo ======2 running day ======
/usr/bin/uptime |awk '{print $3,$4}'
}
 
performance_info(){
echo ===============performance_info=======================
echo ======1 CPU used ======
/usr/bin/top -b -n  1 |grep [cC][Pp][Uu] |grep id|awk '{print $2}'| awk -F "u" '{print $1}'| awk -F "%" '{print$1"%"}'
#top -n 1 |grep C[Pp][Uu] |grep id|awk '{print $2}'| awk -F "%" '{print $1}'| while read line ; do
#echo $line%
#done
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
echo $mem_rate | awk -F "." '{print $1}' | while read line ; do
echo $line%
done
echo ======3 swap used ========
#free -m |grep Swap|awk '{print $2,$3}'
Swap_total=$(free -m |grep Swap|awk '{print $2}')
Swap_used=$(free -m |grep Swap|awk '{print $3}')
Swap_rate=`expr $Swap_used/$Swap_total*100|bc -l`
echo $Swap_rate | awk -F "." '{print $1}' | while read line ;do
echo $line%
done

echo ======4 top pic ==========
/usr/bin/top -b -n 1|head -25

echo ======5 open file===========
/usr/sbin/lsof | wc -l

echo ======6 process_number======
ps aux | wc -l

echo ======7 thread_number======
ps eLf | wc -l

echo ======disk_io_status========
iostat -dxtk | grep -v Linux

echo ======tcp_connect_status====
/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}'
echo ===============sec_info===================================
} 
sec_info(){
echo ======1 user load ======
w
echo ======2 disk_space======
df -ah
echo ======3 demsg error======
dmesg |grep [fF][aA][iI][lL]
#dmesg |grep a
if [ $? -eq 1 ] ; then
echo "=============================
          have no failed log"
fi
dmesg |grep [eE][rR][rR][oO][rR]
if [ $? -eq 1 ] ; then
echo "==============================
          have no error log"
fi
echo ======4 lastlog======
lastlog
echo ======5 /var/log/messages======
cat /var/log/messages | grep [eE][rR][rR][oO][rR]
if [ $? -eq 1 ] ; then
echo  "==============================
          have no error log"
fi
cat /var/log/messages | grep [fF][aA][iI][lL]
if [ $? -eq 1 ] ; then
echo "=============================
          have no failed log"
fi
echo ======6 /var/log/secure======
cat /var/log/secure | grep [eE][rR][rR][oO][rR]
if [ $? -eq 1 ] ; then
echo "=============================
          have no error log"
fi
cat /var/log/secure | grep [fF][aA][iI][lL]
if [ $? -eq 1 ] ; then
echo "=============================
          have no failed log"
fi
}

system_hardware_config(){
echo ===============system_hardware_config==============================
df -H |awk "{OFS=\"\t\"}{ print \$1,\$2,\$3,\$4,\$5,\$6}"
echo ===========================Mem_use=================================
free |head -1 |awk "{OFS=\"\t\"} {print \$1,\$2,\$6}"
free -m |awk "BEGIN{OFS=\"\t\"}{if (NR==2 ||NR==4 )print \$2,\$3,\$7}"
}
 
server_info>>/root/shell/normal/.use/.log/$(/bin/hostname)-`date +%F`
OS_info>>/root/shell/normal/.use/.log/$(/bin/hostname)-`date +%F`
performance_info>>/root/shell/normal/.use/.log/$(/bin/hostname)-`date +%F`
sec_info>>/root/shell/normal/.use/.log/$(/bin/hostname)-`date +%F`
system_hardware_config>>/root/shell/normal/.use/.log/$(/bin/hostname)-`date +%F`
echo "run Ok"
