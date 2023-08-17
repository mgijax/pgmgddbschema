#!/bin/csh -f

#
# missing marker location cache
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

select m._marker_key, m.symbol, m._marker_type_key , t.name, u.login, m.modification_date
from mrk_marker m , mrk_types t, mgi_user u
where m._organism_key = 1 and m._marker_status_key in (1)
and m._marker_type_key = t._marker_type_key
and m._modifiedby_key = u._user_key
and not exists (select 1 from mrk_location_cache c where m._marker_key = c._marker_key)
order by m._marker_type_key, m.symbol
;

EOSQL

