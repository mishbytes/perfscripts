#!/bin/sh


INTERVAL=$1
ITERATIONS=$2
COUNT=0
SHORTHOSTNAME=`hostname -s`

echo "Hostname: $SHORTHOSTNAME"
echo "Disk,TotalM,UsedM,FreeM"



while [ $COUNT -lt $ITERATIONS ]
   do
			COUNT=$((COUNT+1))
        CURRTIME=$(date '+%d%m%Y:%H:%M:%S')
        DFUTIL=$(df -m /dev/mapper/vggfs2-sasutil | egrep -v "Filesystem|dev" | awk -F" " '{print $5 "," $1 "," $2 "," $3}')
        DFWORK=$(df -m /dev/mapper/vggfs1-saswork | egrep -v "Filesystem|dev" | awk -F" " '{print $5 "," $1 "," $2 "," $3}')
        echo "$CURRTIME,$DFUTIL"
        echo "$CURRTIME,$DFWORK"
      if [ $COUNT -ne $ITERATIONS ]; then
       sleep $INTERVAL
      fi       
   done
