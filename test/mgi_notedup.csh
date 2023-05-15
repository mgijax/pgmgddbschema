#!/bin/csh -f

#
# check for markers that do not have wild type alleles
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

select _mgitype_key, _notetype_key, _object_key, note 
into temp dupnotes
from mgi_note  
group by _mgitype_key, _notetype_key, _object_key, note 
having count(*) > 1
;

select n._note_key, n._object_key, n._mgitype_key, n._notetype_key, substring(n.note, 1, 50), n._createdby_key, n.creation_date, n._modifiedby_key, n.modification_date
from dupnotes d,
mgi_note n
where d._mgitype_key = n._mgitype_key
and d._notetype_key = n._notetype_key
and d._object_key = n._object_key
and d.note = n.note
;

--delete from mgi_note where _note_key in ( 500882, 500386, 500373, 504238, 500421, 502075, 500861, 500440, 503677, 502427, 501898, 500443, 500785, 501647, 500994, 503653, 500908, 502259, 502287, 500945, 501033, 501038, 502214, 501408, 502453, 502266, 502126, 502444, 501236, 500977, 502458, 502252, 502060, 502301, 502242, 502185, 502198, 502352, 502331, 502333, 502189, 502251, 502506, 502557, 502619, 503629, 502491, 502234, 502475, 503214, 502361, 503228, 501999, 501036, 504139, 505269, 504128, 505138, 501509, 505124, 3247545, 1530766987, 267344797, 1361386771, 1361386777, 1361386780, 196650268, 836514712, 910608263, 1655719883, 1641410981, 1641410983, 1695102434,502377,502118) 
;

--delete from mgi_note where _note_key in (36719265,39120846,53084892,65178583,312078223,490883660,1212030871,5037483);

EOSQL

date |tee -a $LOG

