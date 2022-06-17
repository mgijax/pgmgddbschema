#!/bin/csh -f

#
# find ascii characters and replace with '' (nothing)
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

select v._refs_key, v._extractedtext_key
into temp duplicates
from bib_workflow_data v
where v._extractedtext_key = 48804490
group by v._refs_key, v._extractedtext_key having count(*) > 1
;

select c._refs_key, c.jnumid, c.mgiid, c.pubmedid, v._supplemental_key, s.term, v._assoc_key, v.creation_date
from duplicates d, bib_citation_cache c, bib_workflow_data v, voc_term s
where d._refs_key = c._refs_key
and d._refs_key = v._refs_key
and v._supplemental_key = s._term_key
order by c._refs_key, c.mgiid
;

EOSQL

date |tee -a $LOG
