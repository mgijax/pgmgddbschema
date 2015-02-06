#!/bin/sh

#
# cluster all tables
#

cd `dirname $0` && . ./Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

create index acc_accession_0 on mgd.acc_accession (lower(accID));
create index acc_accession_1 on mgd.acc_accession (lower(prefixPart));

create index acc_mgitype_0 on mgd.acc_mgitype (lower(name));

create index all_label_0 on mgd.all_label (lower(label));

create index mgi_notetype on mgd.mgi_notetype (lower(noteType));

create index mgi_synonymtype on mgd.mgi_synonymtype (lower(synonymType));

create index mrk_label on mgd.mrk_label (lower(label));

create index mrk_lcoation_cache on mgd.mrk_lcoation_cache (lower(chromosome));

create index voc_annottype on mgd.voc_annottype (lower(name));

create index voc_term on mgd.voc_term (lower(term));

EOSQL
