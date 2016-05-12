#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
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

EOSQL

#
# install new trigger changes (if necessary)
#$PG_MGD_DBSCHEMADIR/trigger/GXD_Genotype_create.object

date |tee -a $LOG

