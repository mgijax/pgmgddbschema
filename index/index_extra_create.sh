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

create index acc_accession_0 on mgd.acc_accession (lower(accID));

create index acc_accession_1 on mgd.acc_accession (lower(prefixPart));

create index acc_mgitype_0 on mgd.acc_mgitype (lower(name));

create index all_label_0 on mgd.all_label (lower(label));

create index mgi_notetype_0 on mgd.mgi_notetype (lower(noteType));

create index mgi_synonymtype_0 on mgd.mgi_synonymtype (lower(synonymType));

create index mrk_label_0 on mgd.mrk_label (lower(label));

create index mrk_location_cache_0 on mgd.mrk_location_cache (lower(chromosome));

create index voc_annottype_0 on mgd.voc_annottype (lower(name));

create index voc_term_0 on mgd.voc_term (lower(term));

EOSQL