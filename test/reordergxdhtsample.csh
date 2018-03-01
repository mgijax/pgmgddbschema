#!/bin/sh

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG
DROP FUNCTION IF EXISTS GXD_orderHTSample();
EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

CREATE OR REPLACE FUNCTION GXD_orderHTSample (
)
RETURNS VOID AS
\$\$

DECLARE
v_commonname text;
v_organism_key int;
v_mgitype_key int;
v_sequencenum int;

BEGIN

v_sequencenum := max(sequencenum) + 1 from MGI_Organism_MGIType;

FOR v_commonname, v_organism_key, v_mgitype_key IN
select m.commonname, o._organism_key, o._mgitype_key
from mgi_organism m, mgi_organism_mgitype o
where m._organism_key = o._organism_key
and o._mgitype_key = 43
and m.commonname not in ('mouse, laboratory', 'human', 'rat')
order by m.commonname
LOOP
        update MGI_Organism_MGIType
	set sequencenum = v_sequencenum
	where _Organism_key = v_organism_key
	and _MGIType_key = v_mgitype_key;
	v_sequencenum := v_sequencenum + 1;
END LOOP;

END;
\$\$
LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION GXD_orderHTSample() TO public;

EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

select m.commonname, o._organism_key, o._mgitype_key, o.sequencenum
from mgi_organism m, mgi_organism_mgitype o
where m._organism_key = o._organism_key
and o._mgitype_key = 43
and m.commonname not in ('mouse, laboratory', 'human', 'rat')
order by m.commonname
;

select GXD_orderHTSample();

select m.commonname, o._organism_key, o._mgitype_key, o.sequencenum
from mgi_organism m, mgi_organism_mgitype o
where m._organism_key = o._organism_key
and o._mgitype_key = 43
and m.commonname not in ('mouse, laboratory', 'human', 'rat')
order by m.commonname
;

EOSQL

#cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0
#DROP FUNCTION IF EXISTS GXD_orderHTSample();
#EOSQL

date |tee -a $LOG

