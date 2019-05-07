#!/bin/csh -f

#
# Remove obsolete /data/pixeldb JPGs
#

if ( ${?MGICONFIG} == 0 ) then
        setenv MGICONFIG /usr/local/mgi/live/mgiconfig
endif

source ${MGICONFIG}/master.config.csh

setenv LOG $0.log
rm -rf $LOG
touch $LOG

setenv PIXLOG pixid.log
rm -rf $PIXLOG
touch $PIXLOG

ls ${PIXELDB} > $PIXLOG

date | tee -a $LOG
./pixid.py | tee -a $LOG 
date |tee -a $LOG

