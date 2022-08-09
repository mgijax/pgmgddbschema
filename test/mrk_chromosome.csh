#!/bin/csh -f

#
# check for markers that do not have "assigned" by history
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
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select m.*
from MRK_Marker m
where m._organism_key = 1
and not exists (select 1 from MRK_Chromosome c where m.chromosome = c.chromosome)
;

EOSQL

date |tee -a $LOG

