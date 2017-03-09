#!/bin/sh

#
# remove GXD_ProbePrep rows that no longer used by GXD_Assay
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select count(*) from GXD_ProbePrep;

select g.* 
from GXD_ProbePrep g 
where not exists (select 1 from GXD_Assay a where g._ProbePrep_key = a._ProbePrep_key)
;

delete from GXD_ProbePrep g
where not exists (select 1 from GXD_Assay a where g._ProbePrep_key = a._ProbePrep_key)
;

select g.* 
from GXD_ProbePrep g 
where not exists (select 1 from GXD_Assay a where g._ProbePrep_key = a._ProbePrep_key)
;

select count(*) from GXD_ProbePrep;

EOSQL

date | tee -a $LOG

