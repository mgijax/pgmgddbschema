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

-- strains with mgi_reference_assoc where referenve/jnum is nuill

select s._strain_key, s.strain
from prb_strain s, mgi_reference_assoc rs, bib_citation_cache c
where s._strain_key = rs._object_key
and rs._mgitype_key = 10
and rs._refs_key = c._refs_key
and c.jnumid is null
order by s.strain
;

EOSQL

date |tee -a $LOG
