#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from acc_accession a
where a._mgitype_key = 9
and not exists (select 1 from img_image s where a._object_key = s._image_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Annot_key);

select * from toDelete;

delete FROM ACC_Accession
using toDelete
WHERE toDelete._Accession_key = ACC_Accession._Accession_key
;

select count(*)
from acc_accession a
where a._mgitype_key = 9
and not exists (select 1 from img_image s where a._object_key = s._image_key)
;

select count(*)
from acc_accession a
where a._mgitype_key = 9
and exists (select 1 from img_image s where a._object_key = s._image_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_note a
where a._mgitype_key = 3
and not exists (select 1 from prb_probe g where a._object_key = s._probe_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Annot_key);

select * from toDelete;

delete FROM mgi_note
using toDelete
WHERE toDelete._probe_key = mgi_note._probe_key
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 3
and not exists (select 1 from prb_probe g where a._object_key = s._probe_key)
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 3
and exists (select 1 from prb_probe g where a._object_key = s._probe_key)
;

EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/trigger/GXD_Genotype_create.object

date |tee -a $LOG

