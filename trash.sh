#!/bin/bash
TRASHLOG=/tmp/.trash_monitor.log
TRASHLOG1=/tmp/.trash_no_monitor.log
REMOVEPATH=$HOME/.trash
TRASHTIME=$(date +"%F_%T")
rmDirTag=0                              #1:with -r or -rf;0:without -r or -rf
rmStatus=0                              #0:exit with no error;1:exit with errors

allowPath=/home/weblogic/test

if [ ! -d $REMOVEPATH ]; then
   mkdir $REMOVEPATH
fi

if (( $# < 1 )); then
   echo "rm: missing operand"
   exit 1
fi

#with or without param -r or -rf
for i in $@ ; do
    if [ $i = "-rf" -o $i = "-r" ]; then
        rmDirTag=1
        #echo "rmDirTag:$rmDirTag"
    fi
done

#check use mv or /bin/rmtrue
function checkPath() {
    cat /etc/allowpath.ini | while read line
    do
        #echo $1
        if [ "$1" == "$line" ]; then
            return 1
        else
            return 0
        fi
    done
}

#normal file
for i in $@ ; do
    #skip -rf and -r
    if [ $i = "-rf" -o $i = "-r" ]; then
        continue
    fi

    #rm a path without -r or -rf
    if [ -d $i -a $rmDirTag -eq 0 ]; then
        echo "rm: cannot remove \`$i': Is a directory"
        rmStatus=1
        continue
    fi
    
    checkPath $(cd `dirname $i`; pwd)
    if [ "$?" == "1" ]; then
        echo -e "$TRASHTIME BIGFILE: `whoami` $0 $i" >> $TRASHLOG1
        /bin/rmtrue -r $i
        continue
    fi
    
    #logging rm history
    if [ "`echo $i | egrep -i log`" ];then
        echo -e "$TRASHTIME `whoami` $0 $i" >> $TRASHLOG1
    else
        echo -e "$TRASHTIME `whoami` $0 $i" >>$TRASHLOG
    fi

    #mv replace rm
    if [ -n "${i##*/}" ];then
        /bin/mv $i $REMOVEPATH/"${i##*/}"_"$TRASHTIME"
    else
        /bin/mv $i $REMOVEPATH/"`echo "$i" | awk -F "/" '{print ($(NF-1))}'`"_"$TRASHTIME"
    fi
done
exit $rmStatus
