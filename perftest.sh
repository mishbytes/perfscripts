#!/bin/sh

#/sas94/lev1/resources/perftest/
#mkdir -p /sas94/sasdata/saswork/perftest

NOW=$(date '+%Y%m%d%H%M%S')
CURRTIME=$(date '+%d%m%Y:%H:%M:%S')
dir="$( cd -P "$( dirname "$0" )" && pwd )" 
script="$dir/$(basename "$0")" 

SHORTHOSTNAME=`hostname -s`

#exec &>> $LOGFILE

SASCMD=/sas94/sashome/SASFoundation/9.4/sas
SASCODELOC=$dir/SASCode/workload
LOGBASE=/sas94/lev1/resources/perftest/logs/
SLEEPINTERVAL=1

logdirname=${NOW}_${SHORTHOSTNAME}
#create separate log directory
mkdir -p $LOGBASE/$logdirname

LOGLOC=$LOGBASE/$logdirname

SORTITERATIONS=$1
SUMMARYITERATIONS=$2
COUNT=0

echo "Start Time: $CURRTIME" >> $LOGLOC/audit.txt
echo "Sort Count: $SORTITERATIONS" >> $LOGLOC/audit.txt
echo "Summary Count: $SUMMARYITERATIONS" >> $LOGLOC/audit.txt


# Set config file path
SASCFGPATH="/sas94/lev1/sashome/SASFoundation/9.4/sasv9.cfg,/sas94/lev1/resources/perftest/sasv9.cfg"
export SASCFGPATH

  while [ $COUNT -lt $SORTITERATIONS ]
  do
			COUNT=$((COUNT+1))
 		  echo "           launching PROC SORT iteration: $COUNT"
			$SASCMD -log $LOGLOC/sortrandom_$COUNT.#Y.#m.#d_#H.#M.#s.log -fullstimer -batch -noterminal -logparm "rollover=session"  -sysin $SASCODELOC/sortrandom.sas &
      
      if [ $COUNT -ne $SORTITERATIONS ]; then
      echo "           Sleep: $SLEEPINTERVAL seconds"
      sleep $SLEEPINTERVAL
      fi
       
  done

COUNT=0
 
  while [ $COUNT -lt $SUMMARYITERATIONS ]
  do
			COUNT=$((COUNT+1))
      
       echo "           launching PROC SUMMARY iteration: $COUNT"
			$SASCMD -log $LOGLOC/summaryrandom_$COUNT.#Y.#m.#d_#H.#M.#s.log -fullstimer -batch -noterminal -logparm "rollover=session"  -sysin $SASCODELOC/summaryrandom.sas &
      
      if [ $COUNT -ne $SUMMARYITERATIONS ];then
      echo "           Sleep: $SLEEPINTERVAL seconds"
      sleep $SLEEPINTERVAL
      fi
       
  done
echo "           waiting for all perf workload to complete"
wait

CURRTIME=$(date '+%d%m%Y:%H:%M:%S')

echo "End Time: $CURRTIME" >> $LOGLOC/audit.txt

echo "           perf test completed"

exit
