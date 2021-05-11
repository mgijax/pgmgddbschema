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

SELECT a.accID, m.symbol as oldSymbol, m.name as oldName
FROM MRK_Marker m, ACC_Accession a
WHERE m._Organism_key = 1 
     AND m._Marker_Status_key = 1
and m._marker_key = a._object_key
and m._marker_status_key in (1,3)
and a._mgitype_key = 2
and a.preferred = 1
and a._logicaldb_key = 1
     AND not exists(select 1 from MRK_History h
        where m._Marker_key = h._History_key
        AND m._Marker_key = h._Marker_key
        AND h._Marker_Event_key = 1
        )
order by m.symbol
;

EOSQL

date |tee -a $LOG

