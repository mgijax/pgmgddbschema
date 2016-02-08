#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_note a
where a._mgitype_key = 3
and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Note_key);

select * from toDelete;

delete FROM mgi_note
using toDelete
WHERE toDelete._note_key = mgi_note._note_key
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 3
and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 3
and exists (select 1 from prb_probe s where a._object_key = s._probe_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_note a
where a._mgitype_key = 9
and not exists (select 1 from img_image s where a._object_key = s._image_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Note_key);

select * from toDelete;

delete FROM mgi_note
using toDelete
WHERE toDelete._note_key = mgi_note._note_key
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 9
and not exists (select 1 from img_image s where a._object_key = s._image_key)
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 9
and exists (select 1 from img_image s where a._object_key = s._image_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_note a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Note_key);

select * from toDelete;

delete FROM mgi_note
using toDelete
WHERE toDelete._note_key = mgi_note._note_key
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 10
and exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_note a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Note_key);

select * from toDelete;

delete FROM mgi_note
using toDelete
WHERE toDelete._note_key = mgi_note._note_key
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 11
and exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.* 
from mgi_note a
where a._mgitype_key = 12
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_Note_key);

select * from toDelete;

delete FROM mgi_note
using toDelete
WHERE toDelete._note_key = mgi_note._note_key
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 12
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

select count(a.*)
from mgi_note a
where a._mgitype_key = 12
and exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.*
from map_coord_feature a
where a._mgitype_key = 2 
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

CREATE INDEX toDelete_idx1 ON toDelete(_feature_key);

select * from toDelete;

delete FROM map_coord_feature
using toDelete
WHERE toDelete._feature_key = map_coord_feature._feature_key
;

select count(a.*)
from map_coord_feature a
where a._mgitype_key = 2 
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from map_coord_feature a
where a._mgitype_key = 2 
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE TEMP TABLE toDelete
as select a.*
from mgi_synonym a
where a._mgitype_key = 21
and not exists (select 1 from nom_marker s where a._object_key = s._nomen_key)

;

CREATE INDEX toDelete_idx1 ON toDelete(_synonym_key);

select * from toDelete;

delete FROM mgi_synonym
using toDelete
WHERE toDelete._synonym_key = mgi_synonym._synonym_key
;

select count(a.*)
from mgi_synonym a
where a._mgitype_key = 21
and not exists (select 1 from nom_marker s where a._object_key = s._nomen_key)
;

select count(a.*)
from mgi_synonym a
where a._mgitype_key = 21
and exists (select 1 from nom_marker s where a._object_key = s._nomen_key)
;

EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/trigger/GXD_Genotype_create.object

date |tee -a $LOG
