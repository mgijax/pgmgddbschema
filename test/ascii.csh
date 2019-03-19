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

select a.accID, r._result_key, regexp_replace(r.resultnote, '([^[:ascii:]])', '', 'g') as markerd_up
from gxd_insituresult r, gxd_specimen s, acc_accession a
where r.resultnote ~ '[^[:ascii:]]'
and r._specimen_key = s._specimen_key
and s._assay_key = a._object_key
and a._mgitype_key = 8
;

EOSQL

date |tee -a $LOG
