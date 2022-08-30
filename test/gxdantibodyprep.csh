#!/bin/sh

#
# remove GXD_AntibodyPrep rows that no longer used by GXD_Assay
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select count(*) from GXD_AntibodyPrep;

select g.* 
from GXD_AntibodyPrep g 
where not exists (select 1 from GXD_Assay a where g._AntibodyPrep_key = a._AntibodyPrep_key)
;

delete from GXD_AntibodyPrep g
where not exists (select 1 from GXD_Assay a where g._AntibodyPrep_key = a._AntibodyPrep_key)
;

select g.* 
from GXD_AntibodyPrep g 
where not exists (select 1 from GXD_Assay a where g._AntibodyPrep_key = a._AntibodyPrep_key)
;

select count(*) from GXD_AntibodyPrep;

EOSQL

date | tee -a $LOG

