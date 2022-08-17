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
from mgi_organism m
where not exists (select 1 from ACC_LogicalDB a where m._organism_key = a._organism_key)
and not exists (select 1 from GXD_Antibody a where m._organism_key = a._organism_key)
and not exists (select 1 from GXD_HTSample a where m._organism_key = a._organism_key)
and not exists (select 1 from GXD_HTSample_RNASeqSet a where m._organism_key = a._organism_key)
and not exists (select 1 from MGI_Organism_MGIType a where m._organism_key = a._organism_key)
and not exists (select 1 from MGI_SynonymType a where m._organism_key = a._organism_key)
and not exists (select 1 from MRK_Chromosome a where m._organism_key = a._organism_key)
and not exists (select 1 from MRK_DO_Cache a where m._organism_key = a._organism_key)
and not exists (select 1 from MRK_Label a where m._organism_key = a._organism_key)
and not exists (select 1 from MRK_Label a where m._organism_key = a._organism_key)
and not exists (select 1 from MRK_Location_Cache a where m._organism_key = a._organism_key)
and not exists (select 1 from MRK_Marker a where m._organism_key = a._organism_key)
and not exists (select 1 from PRB_Source a where m._organism_key = a._organism_key)
and not exists (select 1 from SEQ_Marker_Cache a where m._organism_key = a._organism_key)
and not exists (select 1 from SEQ_Sequence a where m._organism_key = a._organism_key)
;

EOSQL

date |tee -a $LOG

