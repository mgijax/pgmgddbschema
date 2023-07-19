#!/bin/sh

#
# GXD_ProbePrep rows that no longer used by GXD_Assay
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select a.accid, g.* 
from acc_accession a, gxd_gellane g 
where not exists (select 1 from gxd_gelband gb where g._gellane_key = gb._gellane_key)
and g._assay_key = a._object_key
and a._mgitype_key = 8
;

EOSQL

date | tee -a $LOG

