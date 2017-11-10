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

WITH mgiid AS
(
select accid from acc_accession where _logicaldb_key = 1 and prefixpart = 'MGI:' and numericpart >= 5913948 group by accid having count(*) > 1
)
select a._accession_key, a.accid, a.numericpart, a._mgitype_key
from acc_accession a, mgiid m
where m.accid = a.accid
;

EOSQL

date |tee -a $LOG
