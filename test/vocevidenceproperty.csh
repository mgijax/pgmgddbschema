#!/bin/csh -f

#
# purpose:
#
# check if there are no Annotations for:
#
# 1003 | InterPro/Marker
# 1007 | PIRSF/Marker
# 1008 | Strain/Needs Review
# 1009 | Strain/Attributes
# 1011 | MCV/Marker
# 1014 | Allele/Subtype
# 1017 | Protein Ontology/Marker
# 1020 | DO/Genotype
# 1021 | DO/Allele
# 1022 | DO/Human Marker
# 1024 | HPO/DO
# 1025 | MCV/StrainMarker
# 1026 | Allele Variant Type
# 1027 | Allele Variant Effect
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

--select * from VOC_AnnotType order by name;

select v._annottype_key, v.name
from VOC_AnnotType v
where exists (select 1 from VOC_Annot a, VOC_Evidence e
        where v._annottype_key = a._annottype_key
        and a._annot_key = e._annot_key
        )
;

select v._annottype_key, v.name
from VOC_AnnotType v
where exists (select 1 from VOC_Annot a, VOC_Evidence e, VOC_Evidence_Property p
        where v._annottype_key = a._annottype_key
        and a._annot_key = e._annot_key
        and e._annotevidence_key = p._annotevidence_key
        )
;

EOSQL

date |tee -a $LOG
