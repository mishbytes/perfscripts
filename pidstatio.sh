#!/bin/sh


INTERVAL=$1
ITERATIONS=$2
COUNT=0
SHORTHOSTNAME=`hostname -s`

echo "Hostname: $SHORTHOSTNAME"
echo "Timestamp          PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command"

  while [ $COUNT -lt $ITERATIONS ]
   do
			COUNT=$((COUNT+1))
      for PERFTESTPID in `ps -ef | grep -i random | grep -v grep | grep -v Linux | awk -F" " '{print $2}' `; do
         pidstat -p $PERFTESTPID -d | egrep -v "Linux|PID" 
      done #For Loop end
      if [ $COUNT -ne $ITERATIONS ]; then
       sleep $INTERVAL
      fi       
   done


