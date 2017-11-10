#!/bin/csh -f

if ( ${?MGICONFIG} == 0 ) then
        setenv MGICONFIG /usr/local/mgi/live/mgiconfig
endif

source ${MGICONFIG}/master.config.csh

setenv LOG $0.log
rm -rf $LOG
touch $LOG

date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select * from acc_accessionmax;

WITH jnum AS
(
select jnumid from bib_citation_cache group by jnumid having count(*) > 1
)
select b._refs_key, b.numericpart, b.jnumID
from bib_citation_cache b, jnum j
where j.jnumid = b.jnumid
;

EOSQL

date |tee -a $LOG
