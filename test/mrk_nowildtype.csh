#!/bin/csh -f

#
# check for markers that do not have wild type alleles
# 

if ( ${?MGICONFIG} == 0 ) then
        setenv MGICONFIG /usr/local/mgi/live/mgiconfig
endif

source ${MGICONFIG}/master.config.csh

cd `dirname $0`

setenv LOG $0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

SELECT a.accID, m.*
FROM MRK_Marker m, ACC_Accession a
WHERE m._Organism_key = 1 
and m._Marker_Status_key = 1
and m._marker_key = a._object_key
and a._mgitype_key = 2
and a.preferred = 1
and a._logicaldb_key = 1
and m._Marker_Type_key = 1
and m.symbol not like 'mt-%'
and m.name not like 'withdrawn, =%'
and m.name not like '%dna segment%'
and m.name not like 'EST %'
and m.name not like '%expressed sequence%'
and m.name not like '%cDNA sequence%'
and m.name not like '%gene model%'
and m.name not like '%hypothetical protein%'
and m.name not like '%ecotropic viral integration site%'
and m.name not like '%viral polymerase%'
     AND not exists(select 1 from ALL_Allele a
        where m._Marker_key = a._Marker_key
        AND a.iswildtype = 1

        )
order by m.creation_date, m.symbol
;

EOSQL

date |tee -a $LOG

