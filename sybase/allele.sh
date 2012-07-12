#!/bin/sh

#
# cleanup for postgres migration
#
# VOC_Annot_Count_Cache
#	. _MGIType_key
#
# VOC_Marker_Cache
#	. _Term_key
#

cd `dirname $0` && . ../Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

select t.term, a.* 
from ALL_Allele_Mutation a, VOC_Term t
where not exists (select 1 from ALL_Allele b where a._allele_key = b._allele_key)
and a._mutation_key = t._term_key
;

EOSQL

