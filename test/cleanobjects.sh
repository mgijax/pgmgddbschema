#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete1 AS
select a.*, t._mgitype_key as _mgitype_key_t, t._notetype_key as _notetype_key_t
from mgi_note a, mgi_notetype t
where a._notetype_key = t._notetype_key
and a._mgitype_key != t._mgitype_key
and a._mgitype_key in (12)
;

select t.*, n.note 
from toDelete1 t, mgi_notechunk n
where t._note_key = n._note_key
;

CREATE INDEX toDelete1_idx1 ON toDelete1(_note_key);
select * from toDelete1;
delete FROM mgi_note
using toDelete1
WHERE toDelete1._note_key = mgi_note._note_key
;

--DELETE FROM ACC_Accession WHERE _MGIType_key = 38; 
--DELETE FROM ACC_MGITYPE WHERE _MGIType_key = 38; 

EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/???

date |tee -a $LOG

