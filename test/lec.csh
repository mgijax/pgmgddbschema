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

select r.*
from bib_citation r, bib_workflow_data d 
where r._refs_key = d._Refs_key and d.haspdf = 1 and d.extractedtext is not         nul

WITH refs as (
select _Refs_key, pubmedID from BIB_Citation_Cache where pubmedid is not null
)
select r.*, b.journal, b.title
from refs r, BIB_Refs b, BIB_Workflow_Data d
where r._refs_key = b._Refs_key
and b._Refs_key = d._refs_key
and d.hasPDF = 1
and d.extractedText not like '%' || b.title || '%'
;

EOSQL

date |tee -a $LOG

