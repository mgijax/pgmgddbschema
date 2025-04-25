#!/bin/csh -f

#
# find bib counts by month
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

select count(r._refs_key), date_trunc('month', r.creation_date + interval '-1 day') - interval '1 day' as monthly
from BIB_Refs r
where date_part('year', r.creation_date) = date_part('year', CURRENT_DATE)
group by monthly
order by monthly
;

EOSQL

date |tee -a $LOG
