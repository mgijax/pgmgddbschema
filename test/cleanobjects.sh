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

CREATE TEMP TABLE toDelete1 AS
select a.* 
from mgi_reference_assoc a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;
CREATE INDEX toDelete1_idx1 ON toDelete1(_assoc_key);
select * from toDelete1;
delete FROM mgi_reference_assoc
using toDelete1
WHERE toDelete1._assoc_key = mgi_reference_assoc._assoc_key
;


CREATE TEMP TABLE toDelete2 AS
select a.* 
from mgi_reference_assoc a
where a._mgitype_key = 21
and not exists (select 1 from nom_marker s where a._object_key = s._nomen_key)
;
CREATE INDEX toDelete2_idx1 ON toDelete2(_assoc_key);
select * from toDelete2;
delete FROM mgi_reference_assoc
using toDelete2
WHERE toDelete2._assoc_key = mgi_reference_assoc._assoc_key
;


CREATE TEMP TABLE toDelete3 AS
select a.* 
from mgi_reference_assoc a
where a._mgitype_key = 29
and not exists 
(select 1 from img_imagepane_assoc s where a._mgitype_key = s._mgitype_key and a._object_key = s._object_key)
;
CREATE INDEX toDelete3_idx1 ON toDelete3(_assoc_key);
select * from toDelete3;
delete FROM mgi_reference_assoc
using toDelete3
WHERE toDelete3._assoc_key = mgi_reference_assoc._assoc_key
;


EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/trigger/GXD_Genotype_create.object

date |tee -a $LOG

