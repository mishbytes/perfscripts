#!/bin/sh




# DO NOT DELETE THIS LINE
. /sas94/lev1/resources/perftest/bin/setenv.sh

DIR=/sas94/lev1/resources/perftest

NOW=$(date '+%Y%m%d%H%M%S')
CURRTIME=$(date '+%d%m%Y:%H:%M:%S')
SHORTHOSTNAME=`hostname -s`
COMPLEXITY=complex

SASCODELOC=$SASCODE/$COMPLEXITY


DIRNAME=${NOW}_${SHORTHOSTNAME}

#create separate log directory
mkdir -p $LOGBASE/$DIRNAME/$COMPLEXITY
LOGLOC=$LOGBASE/$DIRNAME/$COMPLEXITY

#create separate log directory
mkdir -p $SASPRINTOUTPUT/$DIRNAME/$COMPLEXITY
PRINTLOC=$SASPRINTOUTPUT/$DIRNAME/$COMPLEXITY


SLEEPINTERVAL=1
ITERATIONS=$1

echo "Start Time: $CURRTIME" >> $LOGLOC/audit.txt
echo "EG Simulation Job Count: $EGIOITERATIONS" >> $LOGLOC/audit.txt


COUNT=0  
    while [ $COUNT -lt $ITERATIONS ]
  do
			COUNT=$((COUNT+1))
      SASOPT_LOG="$SASOPT -LOG $LOGLOC/helloworld_$COUNT.#Y.#m.#d_#H.#M.#s.log -PRINT $PRINTLOC/helloworld_$COUNT.lst "      
      echo "           launching EG simulation iteration: $COUNT"
            
      echo $GSUB ?? -gridsubmitpgm  $SASCODELOC/helloworld.sasq -GRIDJOBNAME helloworld_${COMPLEXITY}_$COUNT  $GRIDOPT -GRIDSASOPTS "($SASOPT_LOG)" 
        
      if [ $COUNT -ne $ITERATIONS ]; then
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


exit

