#!/bin/csh -f

#
# Template
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

-- strains that have a MGI:xxx where preferred = 0
-- but don't have a MGI:xxx where preferred = 1

select a._accession_key, a.accid, a.creation_date, a.preferred, a._object_key, s.strain
from acc_accession a , prb_strain s
where a._mgitype_key = 10 
and a._logicaldb_key = 1 
and a.preferred = 0
and a._object_key = s._strain_key
and not exists 
   (select 1 from acc_accession aa where aa._mgitype_key = 10 and aa._logicaldb_key = 1 and aa.preferred = 1 and a._object_key = aa._object_key)
order by s.strain
;

EOSQL

date |tee -a $LOG
