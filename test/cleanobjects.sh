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

-- notes where _mgitype_key = 13 but voc_term does not exist
select a.*
from mgi_note a
where a._mgitype_key = 13
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

delete from mgi_note a
where a._mgitype_key = 13
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

-- notes where _mgitype_key = 25 but voc_evidence does not exist
select a.*
from mgi_note a
where a._mgitype_key = 25
and not exists (select 1 from voc_evidence s where a._object_key = s._annotevidence_key)
;

delete from mgi_note a
where a._mgitype_key = 25
and not exists (select 1 from voc_evidence s where a._object_key = s._annotevidence_key)
;

-- notes that are _mgitype_key = 12 but should be _mgitype_key = 25
CREATE TEMP TABLE toUpdate AS
select n.*
from VOC_Annot a, VOC_Evidence e, MGI_Note_VocEvidence_View n
where a._Annot_key = e._Annot_key
and e._AnnotEvidence_key = n._Object_key
and a._annottype_key = 1020
and n._mgitype_key = 12
order by n._Object_key, n.sequenceNum
;

update MGI_Note n
set _mgitype_key = 25
from toUpdate u
where n._note_key = u._note_key
;

-- mgi_setmembers
CREATE TEMP TABLE toDeleteSet AS
select a.*
from mgi_setmember a, mgi_set aa
where aa._mgitype_key = 13
and a._set_key = aa._set_key
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

select t.* from toDeleteSet t;

CREATE INDEX toDeleteSet_idx1 ON toDeleteSet(_setmember_key);
select * from toDeleteSet;

DELETE FROM mgi_setmember
USING toDeleteSet
WHERE toDeleteSet._setmember_key = mgi_setmember._setmember_key
;

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

-- delete GO Annotations to withdrawn Markers
select * from VOC_deleteGOWithdrawn();

EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/???

# will delete probeprep objects that are obsolete/no longer used by any assay
./gxdprobeprep.csh | tee -a $LOG

date |tee -a $LOG

