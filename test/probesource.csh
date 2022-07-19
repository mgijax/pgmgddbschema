#!/bin/sh

#
# remove PRB_Source rows that no longer used by GXD_Assay
#
# ../key/PRB_Source_create.object:ALTER TABLE mgd.GXD_Antigen ADD FOREIGN KEY (_Source_key) REFERENCES mgd.PRB_Source DEFERRABLE;
# ../key/PRB_Source_create.object:ALTER TABLE mgd.PRB_Probe ADD FOREIGN KEY (_Source_key) REFERENCES mgd.PRB_Source DEFERRABLE;
# ../key/PRB_Source_create.object:ALTER TABLE mgd.SEQ_Source_Assoc_Assoc ADD FOREIGN KEY (_Source_key) REFERENCES mgd.PRB_Source DEFERRABLE;
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select count(*) from PRB_Source;

select g.* 
from PRB_Source g 
where not exists (select 1 from GXD_Antigen a where g._Source_key = a._Source_key)
and not exists (select 1 from GXD_HTExperiment a where g._Source_key = a._Source_key)
and not exists (select 1 from PRB_Probe a where g._Source_key = a._Source_key)
and not exists (select 1 from SEQ_Source_Assoc a where g._Source_key = a._Source_key)
;

delete from PRB_Source g
where not exists (select 1 from GXD_Antigen a where g._Source_key = a._Source_key)
and not exists (select 1 from GXD_HTExperiment a where g._Source_key = a._Source_key)
and not exists (select 1 from PRB_Probe a where g._Source_key = a._Source_key)
and not exists (select 1 from SEQ_Source_Assoc a where g._Source_key = a._Source_key)
;

select g.* 
from PRB_Source g 
where not exists (select 1 from GXD_Antigen a where g._Source_key = a._Source_key)
and not exists (select 1 from GXD_HTExperiment a where g._Source_key = a._Source_key)
and not exists (select 1 from PRB_Probe a where g._Source_key = a._Source_key)
and not exists (select 1 from SEQ_Source_Assoc a where g._Source_key = a._Source_key)
;

select count(*) from PRB_Source;

EOSQL

date | tee -a $LOG

