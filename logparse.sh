#!/bin/sh

#mkdir -p /sas94/sasdata/saswork/perftest

NOW=$(date '+%Y%m%d%H%M%S') 
dir="$( cd -P "$( dirname "$0" )" && pwd )" 
script="$dir/$(basename "$0")" 
LOGFILE="$dir/../logs/logparse.sh.log.$NOW" 

#exec &>> $LOGFILE

SASCMD=/sas94/sashome/SASFoundation/9.4/sas
SASCODELOC=$dir/../SASCode
LOGLOC=/sas94/lev1/resources/perftest/logs/

$SASCMD -log $LOGLOC/readlogs_sas_#Y.#m.#d_#H.#M.#s.log -fullstimer -batch -noterminal -logparm "rollover=session"  -sysin $SASCODELOC/readlogs.sas | tee $LOGFILE


