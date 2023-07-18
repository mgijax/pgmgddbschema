#!/bin/csh -f

#
# purpose:
#
# check if there are any Mouse Markers that do not have their MCV/Marker (1011) Feature Type
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

--select * from VOC_AnnotType order by name;

select v._annottype_key, v.name
from VOC_AnnotType v
where exists (select 1 from VOC_Annot a, VOC_Evidence e, VOC_Evidence_Property p
        where v._annottype_key = a._annottype_key
        and a._annot_key = e._annot_key
        and e._annotevidence_key = p._annotevidence_key
        )
;

select v._annottype_key, v.name
from VOC_AnnotType v
where exists (select 1 from VOC_Annot a, VOC_Evidence e, VOC_Evidence_Property p
        where v._annottype_key = a._annottype_key
        and a._annot_key = e._annot_key
        and e._annotevidence_key = p._annotevidence_key
        )
and v._annottype_key not in (1000,1002,1015,1019,1023,1029,1028)
;

EOSQL

date |tee -a $LOG
