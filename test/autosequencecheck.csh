#!/bin/csh -f

#
# Template
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
select max(_Assoc_key) from ALL_Allele_CellLine;
select last_value from all_allele_cellline_seq;

select max(_CellLine_key) from ALL_CellLine;
select last_value from all_cellline_seq;

select max(_Derication_key) from ALL_CellLine_Derivation;
select last_value from all_cellline_derivation_seq;

select max(_Refs_key) from BIB_Refs;
select last_value from bib_refs_seq;

select max(_Assoc_key) from BIB_Workflow_Status;
select last_value from bib_workflow_status_seq;

select max(_Assoc_key) from BIB_Workflow_Tag;
select last_value from bib_workflow_tag_seq;

select max(_AllelePair_key) from GXD_AllelePair;
select last_value from gxd_allelepair_seq;

select max(_Antigen_key) from GXD_Antigen;
select last_value from gxd_antigen_seq;

select max(_Antibody_key) from GXD_Antibody;
select last_value from gxd_antibody_seq;

select max(_AntibodyAlias_key) from GXD_AntibodyAlias;
select last_value from gxd_antibodyalias_seq;

select max(_AntibodyMarker_key) from GXD_AntibodyMarker;
select last_value from gxd_antibodymarker_seq;

select max(_AntibodyPrep_key) from GXD_AntibodyPrep;
select last_value from gxd_antibodyprep_seq;

select max(_Assay_key) from GXD_Assay;
select last_value from gxd_assay_seq;

select max(_AssayNote_key) from GXD_AssayNote;
select last_value from gxd_assaynote_seq;

select max(_ProbePrep_key) from GXD_ProbePrep;
select last_value from gxd_probeprep_seq;

select max(_Specimen_key) from GXD_Specimen;
select last_value from gxd_specimen_seq;

select max(_Result_key) from GXD_InSituResult;
select last_value from gxd_result_seq;

select max(_ResultStructure_key) from GXD_ISResultStructure;
select last_value from gxd_isresultstructure_seq;

select max(_ResultImage_key) from GXD_InSituResultImage;
select last_value from gxd_insituresultimage_seq;

select max(_GelLaneStructure_key) from GXD_GelLaneStructure;
select last_value from gxd_gellanestructure_seq;

select max(_GelRow_key) from GXD_GelRow;
select last_value from gxd_gelrow_seq;

select max(_GelBand_key) from GXD_GelBand;
select last_value from gxd_gelband_seq;

select max(_Genotype_key) from GXD_Genotype;
select max(_Genotype_key) from GXD_Genotype;
select last_value from gxd_genotype_seq;

select max(_rnaseq_key) from GXD_HTSample_RNASeq;
select last_value from gxd_htsample_rnaseq_seq;

select max(_rnaseqcombined_key) from GXD_HTSample_RNASeqCombined;
select last_value from gxd_htsample_rnaseqcombined_seq;

select max(_rnaseqset_key) from GXD_HTSample_RNASeqSet;
select last_value from gxd_htsample_rnaseqset_seq;

select max(_rnaseqsetmember_key) from GXD_HTSample_RNASeqSetMember;
select last_value from gxd_htsample_rnaseqsetmember_seq;

select max(_Image_key) from IMG_Image;
select last_value from img_image_seq;

select max(_ImagePane_key) from IMG_ImagePane;
select last_value from img_imagepane_seq;

select max(_Assoc_key) from IMG_ImagePane_Assoc;
select last_value from img_imagepane_assoc_seq;

select max(_Assoc_key) from MGI_Reference_Assoc;
select last_value from mgi_reference_assoc_seq;

select max(_Relationship_key) from MGI_Relationship;
select last_value from mgi_relationship_seq;

select max(_Synonym_key) from MGI_Synonym;
select last_value from mgi_synonym_seq;

select max(_marker_key) from MRK_Marker;
select last_value from mrk_marker_seq;

select max(_assoc_key) from MRK_History;
select last_value from mrk_history_seq;

select max(_Strain_key) from PRB_Strain;
select last_value from prb_strain_seq;

select max(_StrainGenotype_key) from PRB_Strain_Genotype;
select last_value from prb_strain_genotype_seq;

select max(_StrainMarker_key) from PRB_Strain_Marker;
select last_value from prb_strain_marker_seq;

select max(id) from PWI_Report_Label;
select last_value from pwi_report_label_id_seq;

select max(id) from PWI_Report;
select last_value from pwi_report_id_seq;

select max(_Assoc_key) from SEQ_Source_Assoc;
select last_value from seq_source_assoc_seq;

select max(_Annot_key) from VOC_Annot;
select last_value from voc_annot_seq;

select max(_AnnotEvidence_key) from VOC_Evidence;
select last_value from voc_evidence_seq;

select max(_EvidenceProperty_key) from VOC_Evidence_Property;
select last_value from voc_evidence_property_seq;

select max(_Term_key) from VOC_Term;
select last_value from voc_term_seq;

--cache in production are empty
--select max(_Cache_key) from VOC_Allele_Cache;
--select last_value from voc_allele_cache_seq;

--select max(_Cache_key) from VOC_Annot_Count_Cache;
--select last_value from voc_annot_count_cache_seq;

--select max(_Cache_key) from VOC_GO_Cache;
--select last_value from voc_go_cache_seq;

--select max(_Cache_key) from VOC_Marker_Cache;
--select last_value from voc_marker_cache_seq;

EOSQL

date |tee -a $LOG
