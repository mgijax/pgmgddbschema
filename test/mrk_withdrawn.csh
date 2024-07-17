#!/bin/csh -f

#
# withdrawn markers that still contain their mgi acc_accession ids
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

select a._accession_key, a.accid, m._marker_key as oldkey, m.symbol as oldsymbol, m.name, mm.symbol, mm._marker_key
from mrk_marker m, acc_accession a, mrk_history h, mrk_marker mm
where m._organism_key = 1 and m.name like 'withdrawn, = %' and m._marker_key = a._object_key and a._mgitype_key = 2
and m._marker_key = h._history_key
and h._marker_key = mm._marker_key
;

EOSQL

