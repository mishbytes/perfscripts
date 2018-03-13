#!/bin/sh


INTERVAL=$1
ITERATIONS=$2
COUNT=0
HOSTNAME=`hostname -f`

srch_str_sort=sortrandom
srch_str_summary=summaryrandom
srch_str_eg=eg_sim

echo "Timestamp,SummaryJobs,SortJobs,EGJobs,HOSTNAME" 
  while [ $COUNT -lt $ITERATIONS ]
   do
			COUNT=$((COUNT+1))
            
      CURRTIME=$(date '+%d%m%Y:%H:%M:%S')
      sortcount=`ps -ef | grep -i "$srch_str_sort" | grep -v grep | wc -l`
      summarycount=`ps -ef | grep -i "$srch_str_summary" | grep -v grep | wc -l`      
      egcount=`ps -ef | grep -i "$srch_str_eg" | grep -v grep | wc -l`
      echo "$CURRTIME,$summarycount,$sortcount,$egcount,$HOSTNAME"      
      if [ $COUNT -ne $ITERATIONS ]; then
       sleep $INTERVAL
      fi       
   done


