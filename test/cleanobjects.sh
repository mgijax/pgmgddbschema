#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

-- mgi_note

-- notes that have no note chunk
select a.* 
from mgi_note a
where not exists (select 1 from mgi_notechunk c where a._note_key = c._note_key)
;
delete from mgi_note a
where not exists (select 1 from mgi_notechunk c where a._note_key = c._note_key)
;

--CREATE TEMP TABLE toDelete1 AS
--select a.*, t._mgitype_key as _mgitype_key_t, t._notetype_key as _notetype_key_t
--from mgi_note a, mgi_notetype t
--where a._notetype_key = t._notetype_key
--and a._mgitype_key != t._mgitype_key
--and a._mgitype_key in (12)
--;

--select t.*, n.note 
--from toDelete1 t, mgi_notechunk n
--where t._note_key = n._note_key
--;

--CREATE INDEX toDelete1_idx1 ON toDelete1(_note_key);
--select * from toDelete1;
--
--DELETE FROM mgi_note
--USING toDelete1
--WHERE toDelete1._note_key = mgi_note._note_key
--;

-- probes

--CREATE TEMP TABLE toDelete2 AS
--select a.* 
--from acc_accession a
--where a._mgitype_key = 3 
--and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
--;

--select t.*
--from toDelete2 t
--;

--CREATE INDEX toDelete2_idx1 ON toDelete2(_accession_key);
--select * from toDelete2;

--DELETE FROM acc_accession
--USING toDelete2
--WHERE toDelete2._accession_key = acc_accession._accession_key
--;

--select a.*
--from mgi_note a
--where not exists (select 1 from mgi_notechunk c where a._note_key = c._note_key)
--;
--delete from mgi_note a
--where not exists (select 1 from mgi_notechunk c where a._note_key = c._note_key)
--;


EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/???

# will delete probeprep objects that are obsolete/no longer used by any assay
./gxdprobeprep.csh | tee -a $LOG

date |tee -a $LOG

