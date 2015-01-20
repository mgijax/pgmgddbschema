#!/bin/sh

#
# Object Group Script
#
# Executes all *_create.logical scripts
#
# Order is important!
#

cd `dirname $0` && . ./Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

DROP FUNCTION ACCRef_insert(int,int);
DROP FUNCTION ACCRef_process(int,int,varchar,int,varchar,int,int);
DROP FUNCTION ACC_assignJ(int,int);
DROP FUNCTION ACC_assignMGI(int,varchar,varchar,int);
DROP FUNCTION ACC_DELETE_byAccKey(int,int);
DROP FUNCTION ACC_insertNoChecks(int,varchar,int,varchar,int,int,int);
DROP FUNCTION ACC_setMax(int,varchar);
DROP FUNCTION ACC_split(varchar);
DROP FUNCTION ACC_update(int,varchar,int,int);

DROP FUNCTION ALL_createWildType(int,varchar);
DROP FUNCTION ALL_insertAllele(int,varchar,varchar,int,int,int,int,int,timestamp,int,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar);

DROP FUNCTION BIB_getCopyright(int);

DROP FUNCTION GXD_removeBadGelBand(int);

DROP FUNCTION MGI_checkUserRole(varchar,varchar);
DROP FUNCTION MGI_insertReferenceAssoc(int,int,int,varchar);
DROP FUNCTION MGI_insertSynonym(int,int,int,varchar,int);
DROP FUNCTION MGI_resetAgeMinMax(varchar,int);
DROP FUNCTION MGI_resetSequenceNum(varchar,int);

DROP FUNCTION MRK_insertHistory(int,int,int,int,int,varchar,timestamp,int,int,timestamp,timestamp);
DROP FUNCTION MRK_reloadLocation(int);
DROP FUNCTION MRK_updateOffset(int,int);

DROP FUNCTION NOM_transferToMGD(int,int);
DROP FUNCTION NOM_updateReserved(varchar);

DROP FUNCTION PRB_ageMinMax(varchar);
DROP FUNCTION PRB_insertReference(int,int);

DROP FUNCTION SEQ_loadMarkerCache(int);
DROP FUNCTION SEQ_loadProbeCache(int);

DROP FUNCTION VOC_mergeAnnotations(int,int,int);
DROP FUNCTION VOC_mergeTerms(int,int);

EOSQL
