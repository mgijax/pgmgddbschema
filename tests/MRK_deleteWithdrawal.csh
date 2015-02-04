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

#psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG
#
#-- some test markers to use for testing
#
#SELECT m._Marker_key, m.symbol, m.name
#FROM MRK_Marker m
#WHERE _Organism_key = 1
#AND chromosome = 'X'
#AND _Marker_Type_key = 1
#AND m._Marker_Status_key in (1,3)
#AND EXISTS (SELECT 1 FROM PRB_Strain_Marker p where m._Marker_key = p._Marker_key)
#ORDER BY m.symbol
#;
#
#EOSQL
#
#exit 0

#
# Zic3 27576
# Xpl 14863
#

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG

-- Current
--SELECT count(DISTINCT m._Marker_key, m.symbol, m._Marker_Type_key
SELECT count(DISTINCT m._Marker_key)
FROM MRK_Marker m, MRK_Current_View mu
WHERE m._Organism_key = 1
AND m.chromosome = 'X'
AND m._Marker_Type_key = 1
AND mu._Current_key = 14863
AND m._Marker_key = mu._Marker_key
;

-- History

SELECT count(*)
FROM MRK_History_View
WHERE _Marker_key = 14863
;

-- Synonym
SELECT count(*)
FROM MGI_Synonym_MusMarker_View
WHERE _Object_key = 14863
;

-- Strain
SELECT count(mp.*)
FROM PRB_Strain_Marker mp
WHERE mp._Marker_key = 14863
;

-- Strain/Needs Review
SELECT count(mp.*)
FROM PRB_Strain_Marker mp, PRB_Strain_NeedsReview_View p
WHERE mp._Marker_key = 14863
and mp._Strain_key = p._Object_key
;

-- run the sp
SELECT MRK_deleteWithdrawal (14863,22864,-1,'Xpl-rename-1','X-linked polydactyly',1)
;

-- Current

SELECT count(DISTINCT m._Marker_key)
FROM MRK_Marker m, MRK_Current_View mu
WHERE m._Organism_key = 1
AND m.chromosome = 'X'
AND m._Marker_Type_key = 1
AND mu._Current_key = 14863
AND m._Marker_key = mu._Marker_key
;

-- History

SELECT count(*)
FROM MRK_History_View
WHERE _Marker_key = 14863
;

-- Synonym
SELECT count(*)
FROM MGI_Synonym_MusMarker_View
WHERE _Object_key = 14863
;

-- Strain
SELECT count(mp.*)
FROM PRB_Strain_Marker mp
WHERE mp._Marker_key = 14863
;

SELECT count(mp.*)
FROM PRB_Strain_Marker mp, PRB_Strain_NeedsReview_View p
WHERE mp._Marker_key = 14863
and mp._Strain_key = p._Object_key
;

EOSQL

date | tee -a $TESTLOG

