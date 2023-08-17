#!/bin/csh -f

#
# missing mrk_current records
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

select m._marker_key, m.symbol, substring(m.name,14,length(m.name)) as currentname
from mrk_marker m
where m._organism_key = 1
and m.name like 'withdrawn, = %'
and not exists (select 1 from mrk_current c where m._marker_key = c._marker_key)
;

EOSQL

