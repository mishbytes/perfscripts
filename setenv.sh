#!/bin/sh

##  this shell script is used to quickly submit multiple jobs to the grid

# set LSF environment
. /sas94/thirdparty/lsf/conf/profile.lsf

# Grid settings
QUEUE=prod_perftest_q
GRIDCONFIG=/sas94/lev1/resources/perftest/sasgrid/sasgsub.cfg
GSUB='/sasconfig/Rtm/Lev1/Applications/SASGridManagerClientUtility/9.4/sasgsub -METAUSER srv-SASANL-m -METAPASS {SAS002}AC7F81410B98606B4C6CEB355AAF3A7C439E7C2E'

# SAS Options
SASOPT="-memsize 2G -SORTSIZE 1G -CPUCOUNT 4 -BUFSIZE 64k -UBUFSIZE 64k -IBUFSIZE 32767 -BUFNO 10 -UBUFNO 10 -IBUFNO 10 -ALIGNSASIOFILES -logparm 'rollover=session' -autoexec '/sas94/lev1/resources/perftest/sasgrid/autoexec_perftest.sas'"

# Grid client options
GRIDOPT="-GRIDCONFIG $GRIDCONFIG -GRIDAPPSERVER SASApp -GRIDJOBOPTS 'queue=prod_perftest_q'"

LOGBASE=/sas94/lev1/resources/perftest/logs/sas
SASPRINTOUTPUT=/sas94/lev1/resources/perftest/logs/output
SASCODE=/sas94/lev1/resources/perftest/SASCode/workload