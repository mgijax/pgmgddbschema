#!/bin/csh -f

#
# purpose
#
# bib_workflow_status where
#       reference
#       group
#       status
#       > 1 iscurrent = 1
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

select r._refs_key, r._group_key, r._status_key, c.mgiid, t1.term, t2.term, r.iscurrent
from bib_workflow_status r, bib_citation_cache c, voc_term t1, voc_term t2
where r.iscurrent = 1
and r._refs_key = c._refs_key
and r._group_key = t1._term_key
and r._status_key = t2._term_key
group by 1,2,3,4,5,6,7 having count(*) > 1
;

EOSQL

date |tee -a $LOG

