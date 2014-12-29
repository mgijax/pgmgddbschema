#!/bin/csh -f

#
# referential-integrity tests
#
# children with cascading deletes:
#
# children without cascading deletes:
#	. find instances where deleting a child will return PGRES_FATAL_ERROR (7)
#
# table : BIB_Refs
#
# children w/ cascading deletes:
# ACC_AccessionReference
# BIB_Citation_Cache
# BIB_Books
# BIB_DataSet_Assoc
# BIB_Notes
# GXD_Expression
# IMG_Cache
# MRK_Homology_Cache
# MRK_OMIM_Cache
# MRK_Reference
# SEQ_Marker_Cache
# SEQ_Probe_Cache
#
# children other:
#

#setenv MGICONFIG /usr/local/mgi/live/mgiconfig
#setenv MGICONFIG /usr/local/mgi/test/mgiconfig
#source ${MGICONFIG}/master.config.csh

cd `dirname $0`

setenv TESTLOG $0.log
rm -rf $TESTLOG
touch $TESTLOG
 
date | tee -a $TESTLOG
 
#cat - <<EOSQL | doisql.csh $MGD_DBSERVER $MGD_DBNAME $0 | tee -a $TESTLOG
#use $MGD_DBNAME
#go
#EOSQL

#
# testing deletes the should return errors due to referential integrity restrictions
#

foreach i (ALL_CellLine_Derivation ALL_Marker_Assoc CRS_References DAG_DAG GXD_AntibodyAlias GXD_Assay GXD_Index HMD_Homology IMG_Image MGI_Reference_Assoc MGI_Relationship MGI_Synonym MLC_Reference MLD_Expts MLD_Notes MRK_History PRB_Marker PRB_Reference PRB_Source RI_Summary_Expt_Ref SEQ_Allele_Assoc VOC_Vocab VOC_Evidence)

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG

SELECT DISTINCT c._Refs_key, c.jnumID
INTO TEMPORARY refs
FROM BIB_Citation_Cache c,  ${i} a
WHERE a._Refs_key = c._Refs_key
LIMIT 1
;

SELECT * FROM refs WHERE _Refs_key IN (SELECT _Refs_key FROM refs)
;

DELETE FROM BIB_Refs WHERE _Refs_key IN (SELECT _Refs_key FROM refs)
;

EOSQL

end

exit 0

#
# test that a record without any referential integrity checks is properly deleted
#

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG

SELECT DISTINCT c._Refs_key, c.jnumID
INTO TEMPORARY refs
FROM BIB_Citation_Cache c
WHERE NOT EXISTS (SELECT 1 FROM ALL_CellLine_Derivation a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM ALL_Marker_Assoc a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM CRS_References a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM DAG_DAG a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM GXD_AntibodyAlias a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM GXD_Assay a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM GXD_Index a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM HMD_Homology a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM IMG_Image a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MGI_Reference_Assoc a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MGI_Relationship a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MGI_Synonym a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MLC_Reference a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MLD_Expts a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MLD_Notes a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM MRK_History a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM PRB_Marker a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM PRB_Reference a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM PRB_Source a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM RI_Summary_Expt_Ref a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM SEQ_Allele_Assoc a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM VOC_Vocab a WHERE c._Refs_key = a._Refs_key)
AND NOT EXISTS (SELECT 1 FROM VOC_Evidence a WHERE c._Refs_key = a._Refs_key)
LIMIT 1
;

SELECT * FROM refs WHERE _Refs_key IN (SELECT _Refs_key FROM refs)
;

DELETE FROM BIB_Refs WHERE _Refs_key IN (SELECT _Refs_key FROM refs)
;

EOSQL

date | tee -a $TESTLOG

