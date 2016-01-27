#!/bin/sh

cd `dirname $0` && . ./Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

-- acc_accession

-- dag_mode

-- img_imagepane_assoc

-- 11 allele
select count(a.*)
from img_imagepane_assoc a
where _mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

-- 12 genotype
select count(a.*)
from img_imagepane_assoc a
where _mgitype_key = 12
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

-- map_coord_feature

-- map_coordinate

-- mgi_note

-- mgi_property

-- mgi_reference_assoc

-- mgi_setmember

-- mgi_synonym

-- mgi_translation

-- voc_annotheader

select count(a.*)
from voc_annotheader a
where a._annottype_key in (1002)
and not exists (select 1 from gxd_genotype g where a._object_key = g._genotype_key)
;

-- voc_annot

select count(a.*)
from voc_annot a
where a._annottype_key in (1002, 1005)
and not exists (select 1 from gxd_genotype g where a._object_key = g._genotype_key)
;

select count(a.*)
from voc_annot a
where a._annottype_key in (1000, 1003, 1006, 1007, 1010, 1011, 1015, 1016, 1017)
and not exists (select 1 from mrk_marker g where a._object_key = g._marker_key)
;

select count(a.*)
from voc_annot a
where a._annottype_key in (1012, 1014)
and not exists (select 1 from all_allele g where a._object_key = g._allele_key)
;

select a.*
from voc_annot a
where a._annottype_key in (1008, 1009)
and not exists (select 1 from prb_strain g where a._object_key = g._strain_key)
;

EOSQL

date |tee -a $LOG

