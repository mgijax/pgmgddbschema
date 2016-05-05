#!/bin/sh

#
# extra indexes for performance when using "like lower()" searches
#
# should match list of indexes in 'exporter/bin/extraIndexes.py'
#
# these are in their own wrapper so that we can still use the automated
# 'sybase/editcreateindex.sh' in this product
#
# the 'sybase/runexporter.sh' calls this wrapper after it calls 'index_create.sh'
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

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

create index ACC_Accession_0 on mgd.ACC_Accession (lower(accID));

create index ACC_Accession_1 on mgd.ACC_Accession (lower(prefixPart));

create index ACC_MGIType_0 on mgd.ACC_MGIType (lower(name));

create index ALL_Label_0 on mgd.ALL_Label (lower(label));

create index MGI_NoteType_0 on mgd.MGI_NoteType (lower(noteType));

create index MGI_SynonymType_0 on mgd.MGI_SynonymType (lower(synonymType));

create index MRK_Label_0 on mgd.MRK_Label (lower(label));

create index MRK_Location_Cache_0 on mgd.MRK_Location_Cache (lower(chromosome));

create index VOC_AnnotType_0 on mgd.VOC_AnnotType (lower(name));

create index VOC_Term_0 on mgd.VOC_Term (lower(term));

EOSQL
