#!/bin/sh

#/sas94/lev1/resources/perftest/
#mkdir -p /sas94/sasdata/saswork/perftest

NOW=$(date '+%Y%m%d%H%M%S') 
STARTTIME=$(date '+%d%m%Y:%H:%M:%S')
dir="$( cd -P "$( dirname "$0" )" && pwd )" 
script="$dir/$(basename "$0")" 
LOGFILE="$dir/logs/syststat.sh.log.$NOW" 
SHORTHOSTNAME=`hostname -s`
#exec &>> $LOGFILE

#Interval in seconds
INTERVAL=$1
#Number of times to collect stats
STATCOUNT=$2
#STATCOUNT=1

OUTPUTBASE=/sas94/lev1/resources/perftest/sysstats
LOGDIRNAME=${NOW}_${SHORTHOSTNAME}
# create unique output directory
mkdir -p $OUTPUTBASE/$LOGDIRNAME
#change permissions
chown -R srv-SASANL-m $OUTPUTBASE/$LOGDIRNAME

OUTPUTLOC=$OUTPUTBASE/$LOGDIRNAME
AUDITLOC=$OUTPUTLOC/..

#Audit
echo "$SHORTHOSTNAME    Start Time: $STARTTIME" >> $AUDITLOC/audit.txt
echo "$SHORTHOSTNAME    iostatcmd: iostat -xNt $INTERVAL $STATCOUNT" >> $AUDITLOC/audit.txt
echo "$SHORTHOSTNAME    iostatout: $OUTPUTLOC/iostat_$NOW.out" >> $AUDITLOC/audit.txt
echo "$SHORTHOSTNAME    vmstatcmd: vmstat -t $INTERVAL $STATCOUNT" >> $AUDITLOC/audit.txt
echo "$SHORTHOSTNAME    vmstatout: $OUTPUTLOC/vmstat_$NOW.out" >> $AUDITLOC/audit.txt
lvs -o name,vg_name,size,attr,lv_size,stripes,stripesize,lv_read_ahead >> $AUDITLOC/audit.txt

echo "           Initiated iostat -xNt $INTERVAL $STATCOUNT"
#-N displays logical volumn -x Extended statistics -t displays timestamp -m to get rMB/sec and wMB/sec
nohup iostat -xmNzt $INTERVAL $STATCOUNT  > $OUTPUTLOC/iostat.out 2>&1 &

echo "           Initiated vmstat -t $INTERVAL $STATCOUNT"
nohup vmstat -t $INTERVAL $STATCOUNT  > $OUTPUTLOC/vmstat.out 2>&1 &

#echo "           Initiated /sas94/lev1/resources/perftest/bin/countworkload.sh $INTERVAL $STATCOUNT"
#nohup /sas94/lev1/resources/perftest/bin/countworkload.sh $INTERVAL $STATCOUNT > $OUTPUTLOC/sasworkload.out 2>&1 &

#echo "           Initiated /sas94/lev1/resources/perftest/bin/pidstatio.sh $INTERVAL $STATCOUNT"
#nohup /sas94/lev1/resources/perftest/bin/pidstatio.sh $INTERVAL $STATCOUNT > $OUTPUTLOC/pidstatio.out 2>&1 &

#echo "           Initiated /sas94/lev1/resources/perftest/bin/sasworkdiskutil.sh $INTERVAL $STATCOUNT"
#nohup /sas94/lev1/resources/perftest/bin/sasworkdiskutil.sh $INTERVAL $STATCOUNT > $OUTPUTLOC/sasworkdiskutil.out 2>&1 &


echo "           waiting for system statistics collection to complete"
wait
ENDTIME=$(date '+%d%m%Y:%H:%M:%S')
echo "$SHORTHOSTNAME    End Time: $ENDTIME" >> $OUTPUTLOC/../audit.txt

chown -R srv-SASANL-m $OUTPUTBASE/$LOGDIRNAME

echo "           system statistics collection completed"

exit
