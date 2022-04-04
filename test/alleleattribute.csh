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

select v._object_key, v._term_key
into temp duplicates
from voc_annot v
where v._annottype_key = 1014
group by v._object_key, v._term_key having count(*) > 1
;

select a.symbol, t.term, aa.*
from duplicates d, all_allele a, voc_term t, voc_annot aa
where d._object_key = a._allele_key
and d._term_key = t._term_key
and d._object_key = aa._object_key
and d._Term_key = aa._term_key
and aa._annottype_key = 1014
order by a.symbol
;

EOSQL

date |tee -a $LOG
