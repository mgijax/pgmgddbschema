#!/bin/sh

#
# purpose:
#
# since we cannot create referential integrity (foreign key) in poostgres for
# for the _mgitype_key/_object_key instances...
#
# this script is meant to find any obsolete _mgitype_key/_object_key instances
#
# for example:
# any instance where the _mgitype_key/_object_key exists in acc_accession, 
# but does not exist in the "master" object table
#
# if a new _mgitype_key is added to the database, then a new test should be added
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee $0.log

select _mgitype_key, name from acc_mgitype order by _mgitype_key;

-- acc_accession

select distinct _mgitype_key from acc_accession order by _mgitype_key;

select a.*
from acc_accession a
where a._mgitype_key = 1
and not exists (select 1 from bib_refs s where a._object_key = s._refs_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 2
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 3
and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 4
and not exists (select 1 from mld_expts s where a._object_key = s._expt_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 5
and not exists (select 1 from prb_source s where a._object_key = s._source_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 6
and not exists (select 1 from gxd_antibody s where a._object_key = s._antibody_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 7
and not exists (select 1 from gxd_antigen s where a._object_key = s._antigen_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 8
and not exists (select 1 from gxd_assay s where a._object_key = s._assay_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 9
and not exists (select 1 from img_image s where a._object_key = s._image_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 12
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 13
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 19
and not exists (select 1 from seq_sequence s where a._object_key = s._sequence_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 20
and not exists (select 1 from mgi_organism s where a._object_key = s._organism_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 25
and not exists (select 1 from voc_evidence s where a._object_key = s._annotevidence_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 28
and not exists (select 1 from all_cellline s where a._object_key = s._cellline_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 35
and not exists (select 1 from img_imagepane s where a._object_key = s._ImagePane_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 39
and not exists (select 1 from mrk_cluster s where a._object_key = s._cluster_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 42 
and not exists (select 1 from gxd_htexperiment s where a._object_key = s._experiment_key)
;

select a.*
from acc_accession a
where a._mgitype_key = 43
and not exists (select 1 from gxd_htsample s where a._object_key = s._sample_key)
;

-- img_imagepane_assoc

select distinct _mgitype_key from img_imagepane_assoc order by _mgitype_key;

select a.*
from img_imagepane_assoc a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select a.*
from img_imagepane_assoc a
where a._mgitype_key = 12
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

-- map_coord_feature

select distinct _mgitype_key from map_coord_feature order by _mgitype_key;

select a.*
from map_coord_feature a
where a._mgitype_key = 2
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from map_coord_feature a
where a._mgitype_key = 19
and not exists (select 1 from seq_sequence s where a._object_key = s._sequence_key)
;

-- map_coordinate

select distinct _mgitype_key from map_coordinate order by _mgitype_key;

select a.*
from map_coordinate a
where a._mgitype_key = 27
and not exists (select 1 from mrk_chromosome s where a._object_key = s._chromosome_key)
;

-- mgi_note

select distinct _mgitype_key from mgi_notetype order by _mgitype_key;
select distinct _mgitype_key from mgi_note order by _mgitype_key;

select a.*
from mgi_note a
where a._mgitype_key = 1
and not exists (select 1 from bib_refs s where a._object_key = s._refs_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 2
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 3
and not exists (select 1 from prb_probe s where a._object_key = s._probe_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 9
and not exists (select 1 from img_image s where a._object_key = s._image_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select a.*
from mgi_note a, VOC_Annot v, VOC_Evidence e
where a._mgitype_key = 12
and v._Annot_key = e._Annot_key    
and e._AnnotEvidence_key = a._Object_key    
and v._AnnotType_key = 1005
and not exists (select 1 from gxd_genotype s where v._Object_key = s._genotype_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 13
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 19
and not exists (select 1 from seq_sequence s where a._object_key = s._sequence_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 25
and not exists (select 1 from voc_evidence s where a._object_key = s._annotevidence_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 36
and not exists (select 1 from all_cellline_derivation s where a._object_key = s._derivation_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 40
and not exists (select 1 from mgi_relationship s where a._object_key = s._relationship_key)
;

select a.*
from mgi_note a
where a._mgitype_key = 41
and not exists (select 1 from voc_evidence_property s where a._object_key = s._evidenceproperty_key)
;

-- where the note/mgitype is not equal to the notetype/mgitype
select a.*, t._mgitype_key, t._notetype_key 
from mgi_note a, mgi_notetype t 
where a._notetype_key = t._notetype_key
and a._mgitype_key != t._mgitype_key
;

-- mgi_property

select distinct _mgitype_key from mgi_property order by _mgitype_key;

select a.*
from mgi_property a
where a._mgitype_key = 39
and not exists (select 1 from mrk_cluster s where a._object_key = s._cluster_key)
;

-- mgi_relationship

select distinct _mgitype_key_1 from mgi_relationship_category order by _mgitype_key_1;
select distinct _mgitype_key_2 from mgi_relationship_category order by _mgitype_key_2;

select a.*
from mgi_relationship a, mgi_relationship_category aa
where aa._mgitype_key_1 = 2
and aa._Category_key = a._Category_key
and not exists (select 1 from mrk_marker s where a._object_key_1 = s._marker_key)
;

select a.*
from mgi_relationship a, mgi_relationship_category aa
where aa._mgitype_key_2 = 2
and aa._Category_key = a._Category_key
and not exists (select 1 from mrk_marker s where a._object_key_2 = s._marker_key)
;

select a.*
from mgi_relationship a, mgi_relationship_category aa
where aa._mgitype_key_1 = 11
and aa._Category_key = a._Category_key
and not exists (select 1 from all_allele s where a._object_key_1 = s._allele_key)
;

select a.*
from mgi_relationship a, mgi_relationship_category aa
where aa._mgitype_key_2 = 11
and aa._Category_key = a._Category_key
and not exists (select 1 from all_allele s where a._object_key_2 = s._allele_key)
;

-- mgi_reference_assoc

select distinct _mgitype_key from mgi_reference_assoc order by _mgitype_key;

select a.*
from mgi_reference_assoc a
where a._mgitype_key = 2
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from mgi_reference_assoc a
where a._mgitype_key = 6
and not exists (select 1 from gxd_antibody s where a._object_key = s._antibody_key)
;

select a.*
from mgi_reference_assoc a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select a.*
from mgi_reference_assoc a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select a.*
from mgi_reference_assoc a
where a._mgitype_key = 19
and not exists (select 1 from seq_sequence s where a._object_key = s._sequence_key)
;

-- mgi_setmember

select distinct _mgitype_key from mgi_set order by _mgitype_key;

select a.*
from mgi_setmember a, mgi_set aa
where aa._mgitype_key = 13
and a._set_key = aa._set_key
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

-- mgi_synonym

select distinct _mgitype_key from mgi_synonym order by _mgitype_key;

select a.*
from mgi_synonym a
where a._mgitype_key = 2
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from mgi_synonym a
where a._mgitype_key = 10
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select a.*
from mgi_synonym a
where a._mgitype_key = 11
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select a.*
from mgi_synonym a
where a._mgitype_key = 13
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

-- mgi_translation

select distinct _mgitype_key from mgi_translationtype order by _mgitype_key;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 5
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from prb_source s where a._object_key = s._source_key)
;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 10
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 13
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 20
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from mgi_organism s where a._object_key = s._organism_key)
;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 24
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from prb_tissue s where a._object_key = s._tissue_key)
;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 28
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from all_cellline s where a._object_key = s._cellline_key)
;

select a.*
from mgi_translation a, mgi_translationtype aa
where aa._mgitype_key = 36
and a._TranslationType_key = aa._TranslationType_key
and not exists (select 1 from all_cellline_derivation s where a._object_key = s._derivation_key)
;

-- voc_annotheader

select a.*
from voc_annotheader a
where a._annottype_key in (1002)
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

-- voc_annot

select distinct _mgitype_key from voc_annottype order by _mgitype_key;

select a.*
from voc_annot a
where a._annottype_key in (1002, 1005)
and not exists (select 1 from gxd_genotype s where a._object_key = s._genotype_key)
;

select a.*
from voc_annot a
where a._annottype_key in (1000, 1003, 1006, 1007, 1010, 1011, 1015, 1016, 1017, 1019)
and not exists (select 1 from mrk_marker s where a._object_key = s._marker_key)
;

select a.*
from voc_annot a
where a._annottype_key in (1012, 1014)
and not exists (select 1 from all_allele s where a._object_key = s._allele_key)
;

select a.*
from voc_annot a
where a._annottype_key in (1008, 1009)
and not exists (select 1 from prb_strain s where a._object_key = s._strain_key)
;

select a.*
from voc_annot a
where a._annottype_key in (1018)
and not exists (select 1 from voc_term s where a._object_key = s._term_key)
;

EOSQL

date |tee -a $LOG

