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

select max(_Assoc_key) from BIB_Workflow_Status;
select last_value from bib_workflow_status_seq;

select max(_Assoc_key) from BIB_Workflow_Tag;
select last_value from bib_workflow_tag_seq;

select max(_Assoc_key) from IMG_ImagePane_Assoc;
select last_value from img_imagepane_assoc_seq;

select max(_Assoc_key) from MGI_Reference_Assoc;
select last_value from mgi_reference_assoc_seq;

select max(_Synonym_key) from MGI_Synonym;
select last_value from mgi_synonym_seq;

select max(_marker_key) from MRK_Marker;
select last_value from mrk_marker_seq;

select max(_assoc_key) from MRK_History;
select last_value from mrk_history_seq;

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

select max(_Cache_key) from VOC_Allele_Cache;
select last_value from voc_allele_cache_seq;

select max(_Cache_key) from VOC_Annot_Count_Cache;
select last_value from voc_annot_count_cache_seq;

select max(_AnnotEvidence_key) from VOC_Evidence;
select last_value from voc_evidence_seq;

select max(_Cache_key) from VOC_GO_Cache;
select last_value from voc_go_cache_seq;

select max(_Cache_key) from VOC_Marker_Cache;
select last_value from voc_marker_cache_seq;

EOSQL

date |tee -a $LOG
