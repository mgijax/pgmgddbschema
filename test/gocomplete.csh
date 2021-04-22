#!/bin/sh

#
# GO/Complete that do not have GO Annotations anymore
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select distinct m.symbol, mt.name, gt._marker_key, gt.completion_date, u.login
from go_tracking gt, mrk_marker m, mgi_user u, mrk_types mt
where gt._completedby_key is not null
and gt._marker_key = m._marker_key
and m._marker_status_key in (1,3)
and gt._completedby_key = u._user_key
and m._marker_type_key = mt._marker_type_key
and not exists (select 1 from voc_annot v
        where v._annottype_key = 1000
        and gt._marker_key = v._object_key
        )
order by gt.completion_date,m.symbol
;

--delete from go_tracking
--where gt._completedby_key is not null
--and not exists (select 1 from voc_annot v
--        where v._annottype_key = 1000
--        and gt._marker_key = v._object_key
--        )
--;

EOSQL

date | tee -a $LOG

