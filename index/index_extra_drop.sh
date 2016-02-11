#!/bin/sh

#
# extra indexes for performance when using "like lower()" searches
#
# should match list of indexes in 'exporter/bin/extraIndexes.py'
#
# these are in their own wrapper so that we can still use the automated
# 'sybase/editdropindex.sh' in this product
#
# the 'sybase/runexporter.sh' calls this wrapper after it calls 'index_drop.sh'
#

cd `dirname $0` && . ./Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

drop index if exists mgd.ACC_Accession_0
;

drop index if exists mgd.ACC_Accession_1
;

drop index if exists mgd.ACC_MGIType_0
;

drop index if exists mgd.ALL_Label_0
;

drop index if exists mgd.MGI_NoteType_0
;

drop index if exists mgd.MGI_SynonymType_0
;

drop index if exists mgd.MRK_Label_0
;

drop index if exists mgd.MRK_Location_Cache_0
;

drop index if exists mgd.VOC_AnnotType_0
;

drop index if exists mgd.VOC_Term_0
;

EOSQL
