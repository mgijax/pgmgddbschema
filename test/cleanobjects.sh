#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
#cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG
#
#CREATE TEMP TABLE toDelete
#as select a.* 
#from mgi_note a
#where a._mgitype_key = 3
#and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
#;
#
#CREATE INDEX toDelete_idx1 ON toDelete(_Note_key);
#
#select * from toDelete;
#
#delete FROM mgi_note
#using toDelete
#WHERE toDelete._note_key = mgi_note._note_key
#;
#
#select count(a.*)
#from mgi_note a
#where a._mgitype_key = 3
#and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
#;
#
#select count(a.*)
#from mgi_note a
#where a._mgitype_key = 3
#and exists (select 1 from prb_probe s where a._object_key = s._probe_key)
#;
#
#EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_reference_assoc a
where a._mgitype_key = 21
and not exists (select 1 from nom_marker s where a._object_key = s._nomen_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_assoc_key);

select * from toDelete;

delete FROM mgi_reference_assoc
using toDelete
WHERE toDelete._assoc_key = mgi_reference_assoc._assoc_key
;

select a.* 
from mgi_reference_assoc a
where a._mgitype_key = 21
and not exists (select 1 from nom_marker s where a._object_key = s._nomen_key)
;

EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/trigger/GXD_Genotype_create.object

date |tee -a $LOG

