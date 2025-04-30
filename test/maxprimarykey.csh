#!/bin/csh -f

#
# checking max primary key
# integer 4 bytes -2147483648 to 2147483647
#

if ( ${?MGICONFIG} == 0 ) then
        setenv MGICONFIG /usr/local/mgi/live/mgiconfig
endif

source ${MGICONFIG}/master.config.csh

cd `dirname $0`

setenv LOG $0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
rm -rf maxprimarykey.counts
$PYTHON maxprimarykey.py | sort -n > maxprimarykey.counts

date |tee -a $LOG
