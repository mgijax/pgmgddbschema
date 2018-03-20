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

--
-- one jnumber with > 1 reference
--
WITH jnum AS
(
select jnumid from bib_citation_cache group by jnumid having count(*) > 1
)
select b._refs_key, b.numericpart, b.jnumID
from bib_citation_cache b, jnum j
where j.jnumid = b.jnumid
;

--
-- one reference with > 1 jnumber
--
WITH object AS
(
select _object_key from acc_accession where _mgitype_key = 1 and prefixpart = 'J:' group by _object_key having count(*) > 1
)
select a.*
from acc_accession a, object j
where j._object_key = a._object_key
and a._mgitype_key = 1
and a.prefixpart = 'J:'
;

EOSQL

date |tee -a $LOG
