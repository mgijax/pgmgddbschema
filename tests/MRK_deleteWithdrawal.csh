#!/bin/csh -f

#
# Purpose:
#
# To test that MRK_deleteWithdrawal
#
# MRK_Marker
# MRK_Current
# MRK_History
# MGI_Synonynm
# ALL_Allele (wild-type allele)
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
# Ty	14343
#

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG

-- Current
--SELECT count(DISTINCT m._Marker_key, m.symbol, m._Marker_Type_key
SELECT count(DISTINCT m._Marker_key)
FROM MRK_Marker m, MRK_Current_View mu
WHERE m._Organism_key = 1
AND m.chromosome = 'X'
AND m._Marker_Type_key = 1
AND mu._Current_key = 14343
AND m._Marker_key = mu._Marker_key
;

-- History

SELECT count(*)
FROM MRK_History_View
WHERE _Marker_key = 14343
;

SELECT count(*)
FROM MGI_Synonym_MusMarker_View
WHERE _Object_key = 14343
;

-- run the sp
SELECT MRK_deleteWithdrawal (14343,22864,-1)
;

-- Current

SELECT count(DISTINCT m._Marker_key)
FROM MRK_Marker m, MRK_Current_View mu
WHERE m._Organism_key = 1
AND m.chromosome = 'X'
AND m._Marker_Type_key = 1
AND mu._Current_key = 14343
AND m._Marker_key = mu._Marker_key
;

-- History

SELECT count(*)
FROM MRK_History_View
WHERE _Marker_key = 14343
;

-- Synonym
SELECT count(*)
FROM MGI_Synonym_MusMarker_View
WHERE _Object_key = 14343
;

EOSQL

date | tee -a $TESTLOG

