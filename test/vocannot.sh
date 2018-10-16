#!/bin/sh

#
# purpose:
#
# check if there are any Mouse Markers that do not have their MCV/Marker (1011) Feature Type
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee $0.log

select m.* from mrk_marker m 
where m._organism_key = 1 
and m._marker_status_key = 1 
and m._marker_Type_key = 1 
and not exists (select 1 from voc_annot a where m._marker_key = a._object_key and a._annottype_key = 1011)
;

EOSQL

date |tee -a $LOG

