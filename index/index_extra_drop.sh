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

--drop index mgd.acc_accession_0;

--drop index mgd.acc_accession_1;

drop index mgd.acc_mgitype_0;

drop index mgd.all_label_0;

drop index mgd.mgi_notetype_0;

drop index mgd.mgi_synonymtype_0;

drop index mgd.mrk_label_0;

drop index mgd.mrk_location_cache_0;

drop index mgd.voc_annottype_0;

drop index mgd.voc_term_0;

EOSQL
