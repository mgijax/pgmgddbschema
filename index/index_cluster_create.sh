#!/bin/sh

#
# cluster all tables
#

cd `dirname $0` && . ./Configuration


cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

/* clustered indexes that are on the primary key */

CLUSTER acc_accessionmax_pkey on mgd.ACC_AccessionMax;
CLUSTER acc_accessionreference_pkey on mgd.ACC_AccessionReference;
CLUSTER acc_actualdb_pkey on mgd.ACC_ActualDB;
CLUSTER acc_logicaldb_pkey on mgd.ACC_LogicalDB;
CLUSTER acc_mgitype_pkey on mgd.ACC_MGIType;

CLUSTER all_allele_cellline_pkey on mgd.ALL_Allele_CellLine;
CLUSTER all_allele_mutation_pkey on mgd.ALL_Allele_Mutation;
CLUSTER all_cellline_derivation_pkey on mgd.ALL_CellLine_Derivation;
CLUSTER all_cellline_pkey on mgd.ALL_CellLine;
CLUSTER all_label_pkey on mgd.ALL_Label;

CLUSTER bib_books_pkey on mgd.BIB_Books;
CLUSTER bib_citation_cache_pkey on mgd.BIB_Citation_Cache;
CLUSTER bib_dataset_pkey on mgd.BIB_DataSet;
CLUSTER bib_notes_pkey on mgd.BIB_Notes;
CLUSTER bib_refs_pkey on mgd.BIB_Refs;
CLUSTER bib_reviewstatus_pkey on mgd.BIB_ReviewStatus;

CLUSTER crs_cross_pkey on mgd.CRS_Cross;
CLUSTER crs_progeny_pkey on mgd.CRS_Progeny;
CLUSTER crs_references_pkey on mgd.CRS_References;
CLUSTER crs_typings_pkey on mgd.CRS_Typings;

CLUSTER dag_dag_pkey on mgd.DAG_DAG;
CLUSTER dag_label_pkey on mgd.DAG_Label;

CLUSTER go_tracking_pkey on mgd.GO_Tracking;

CLUSTER gxd_allelegenotype_pkey on mgd.GXD_AlleleGenotype;
CLUSTER gxd_antibody_pkey on mgd.GXD_Antibody;
CLUSTER gxd_antibodyclass_pkey on mgd.GXD_AntibodyClass;
CLUSTER gxd_antibodymarker_pkey on mgd.GXD_AntibodyMarker;
CLUSTER gxd_antibodyprep_pkey on mgd.GXD_AntibodyPrep;
CLUSTER gxd_antibodytype_pkey on mgd.GXD_AntibodyType;
CLUSTER gxd_antigen_pkey on mgd.GXD_Antigen;
CLUSTER gxd_assaynote_pkey on mgd.GXD_AssayNote;
CLUSTER gxd_assaytype_pkey on mgd.GXD_AssayType;
CLUSTER gxd_embeddingmethod_pkey on mgd.GXD_EmbeddingMethod;
CLUSTER gxd_fixationmethod_pkey on mgd.GXD_FixationMethod;
CLUSTER gxd_gelcontrol_pkey on mgd.GXD_GelControl;
CLUSTER gxd_gellanestructure_pkey on mgd.GXD_GelLaneStructure;
CLUSTER gxd_gelrnatype_pkey on mgd.GXD_GelRNAType;
CLUSTER gxd_gelunits_pkey on mgd.GXD_GelUnits;
CLUSTER gxd_genotype_pkey on mgd.GXD_Genotype;
CLUSTER gxd_isresultstructure_pkey on mgd.GXD_ISResultStructure;
CLUSTER gxd_insituresultimage_pkey on mgd.GXD_InSituResultImage;
CLUSTER gxd_insituresult_pkey on mgd.GXD_InSituResult;
CLUSTER gxd_index_stages_pkey on mgd.GXD_Index_Stages;
CLUSTER gxd_label_pkey on mgd.GXD_Label;
CLUSTER gxd_pattern_pkey on mgd.GXD_Pattern;
CLUSTER gxd_probeprep_pkey on mgd.GXD_ProbePrep;
CLUSTER gxd_probesense_pkey on mgd.GXD_ProbeSense;
CLUSTER gxd_secondary_pkey on mgd.GXD_Secondary;
CLUSTER gxd_strength_pkey on mgd.GXD_Strength;
CLUSTER gxd_structure_pkey on mgd.GXD_Structure;
CLUSTER gxd_structureclosure_pkey on mgd.GXD_StructureClosure;
CLUSTER gxd_structurename_pkey on mgd.GXD_StructureName;
CLUSTER gxd_theilerstage_pkey on mgd.GXD_TheilerStage;
CLUSTER gxd_visualizationmethod_pkey on mgd.GXD_VisualizationMethod;

CLUSTER hmd_assay_pkey on mgd.HMD_Assay;
CLUSTER hmd_class_pkey on mgd.HMD_Class;
CLUSTER hmd_homology_assay_pkey on mgd.HMD_Homology_Assay;
CLUSTER hmd_homology_marker_pkey on mgd.HMD_Homology_Marker;
CLUSTER hmd_notes_pkey on mgd.HMD_Notes;

CLUSTER img_imagepane_assoc_pkey on mgd.IMG_ImagePane_Assoc;
CLUSTER img_imagepane_pkey on mgd.IMG_ImagePane;
CLUSTER img_image_pkey on mgd.IMG_Image;

CLUSTER map_coord_collection_pkey on mgd.MAP_Coord_Collection;
CLUSTER map_coord_feature_pkey on mgd.MAP_Coord_Feature;
CLUSTER map_coordinate_pkey on mgd.MAP_Coordinate;

CLUSTER mgi_attributehistory_pkey on mgd.MGI_AttributeHistory;
CLUSTER mgi_columns_pkey on mgd.MGI_Columns;
CLUSTER mgi_measurement_pkey on mgd.MGI_Measurement;
CLUSTER mgi_notechunk_pkey on mgd.MGI_NoteChunk;
CLUSTER mgi_notetype_pkey on mgd.MGI_NoteType;
CLUSTER mgi_organism_mgitype_pkey on mgd.MGI_Organism_MGIType;
CLUSTER mgi_organism_pkey on mgd.MGI_Organism;
CLUSTER mgi_refassoctype_pkey on mgd.MGI_RefAssocType;
CLUSTER mgi_roletask_pkey on mgd.MGI_RoleTask;
CLUSTER mgi_setmember_pkey on mgd.MGI_SetMember;
CLUSTER mgi_statisticsql_pkey on mgd.MGI_StatisticSql;
CLUSTER mgi_statistic_pkey on mgd.MGI_Statistic;
CLUSTER mgi_synonymtype_pkey on mgd.MGI_SynonymType;
CLUSTER mgi_synonym_pkey on mgd.MGI_Synonym;
CLUSTER mgi_tables_pkey on mgd.MGI_Tables;
CLUSTER mgi_translationtype_pkey on mgd.MGI_TranslationType;
CLUSTER mgi_translation_pkey on mgd.MGI_Translation;
CLUSTER mgi_userrole_pkey on mgd.MGI_UserRole;
CLUSTER mgi_user_pkey on mgd.MGI_User;
CLUSTER mgi_vocassociationtype_pkey on mgd.MGI_VocAssociationType;
CLUSTER mgi_volaccociation_pkey on mgd.MGI_VocAssociation;

CLUSTER mlc_marker_pkey on mgd.MLC_Marker;
CLUSTER mlc_reference_pkey on mgd.MLC_Reference;
CLUSTER mlc_text_pkey on mgd.MLC_Text;

CLUSTER mld_assay_types_pkey on mgd.MLD_Assay_Types;
CLUSTER mld_concordance_pkey on mgd.MLD_Concordance;
CLUSTER mld_contrigprobe_pkey on mgd.MLD_ContigProbe;
CLUSTER mld_contrig_pkey on mgd.MLD_Contig;
CLUSTER mld_distrance_pkey on mgd.MLD_Distance;
CLUSTER mld_expt_marker_pkey on mgd.MLD_Expt_Marker;
CLUSTER mld_expt_notes_pkey on mgd.MLD_Expt_Notes;
CLUSTER mld_expts_pkey on mgd.MLD_Expts;
CLUSTER mld_fish_region_pkey on mgd.MLD_FISH_Region;
CLUSTER mld_fish_pkey on mgd.MLD_FISH;
CLUSTER mld_hit_pkey on mgd.MLD_Hit;
CLUSTER mld_hybrid_pkey on mgd.MLD_Hybrid;
CLUSTER mld_isregion_pkey on mgd.MLD_ISRegion;
CLUSTER mld_insitu_pkey on mgd.MLD_InSitu;
CLUSTER mld_mc2point_pkey on mgd.MLD_MC2point;
CLUSTER mld_mcdatalist_pkey on mgd.MLD_MCDataList;
CLUSTER mld_matrix_pkey on mgd.MLD_Matrix;
CLUSTER mld_notes_pkey on mgd.MLD_Notes;
CLUSTER mld_physmap_pkey on mgd.MLD_PhysMap;
CLUSTER mld_ri2poit_pkey on mgd.MLD_RI2Point;
CLUSTER mld_ridata_pkey on mgd.MLD_RIData;
CLUSTER mld_ri_pkey on mgd.MLD_RI;
CLUSTER mld_statisitics_pkey on mgd.MLD_Statistics;

CLUSTER mrk_alias_pkey on mgd.MRK_Alias;
CLUSTER mrk_anchors_idx_clustered ON mgd.MRK_Anchors;
CLUSTER mrk_class_pkey on mgd.MRK_Class;
CLUSTER mrk_classes_pkey on mgd.MRK_Classes;
CLUSTER mrk_current_pkey on mgd.MRK_Current;
CLUSTER mrk_eventreason_pkey on mgd.MRK_EventReason;
CLUSTER mrk_event_pkey on mgd.MRK_Event;
CLUSTER mrk_history_pkey on mgd.MRK_History;
CLUSTER mrk_mvc_cache_pkey on mgd.MRK_MCV_Cache;
CLUSTER mrk_mcv_count_cache_pkey on mgd.MRK_MCV_Count_Cache;
CLUSTER mrk_notes_pkey on mgd.MRK_Notes;
CLUSTER mrk_offset_pkey on mgd.MRK_Offset;
CLUSTER mrk_reference_pkey on mgd.MRK_Reference;
CLUSTER mrk_status_pkey on mgd.MRK_Status;
CLUSTER mrk_types_pkey on mgd.MRK_Types;

CLUSTER prb_allele_strain_pkey on mgd.PRB_Allele_Strain;
CLUSTER prb_marker_pkey on mgd.PRB_Marker;
CLUSTER prb_notes_pkey on mgd.PRB_Notes;
CLUSTER prb_ref_notes_pkey on mgd.PRB_Ref_Notes;
CLUSTER prb_strain_pkey on mgd.PRB_Strain;
CLUSTER prb_tissue_pkey on mgd.PRB_Tissue;

CLUSTER ri_riset_pkey on mgd.RI_RISet;
CLUSTER ri_summary_expt_ref_pkey on mgd.RI_Summary_Expt_Ref;
CLUSTER ri_summary_pkey on mgd.RI_Summary;

CLUSTER seq_allele_assoc_pkey on mgd.SEQ_Allele_Assoc;
CLUSTER seq_description_cache_pkey on mgd.SEQ_Description_Cache;
CLUSTER seq_genemodel_pkey on mgd.SEQ_GeneModel;
CLUSTER seq_genetrap_pkey on mgd.SEQ_GeneTrap;
CLUSTER seq_probe_cache_pkey on mgd.SEQ_Probe_Cache;
CLUSTER seq_sequence_raw_pkey on mgd.SEQ_Sequence_Raw;

CLUSTER voc_allele_cache_pkey on mgd.VOC_Allele_Cache;
CLUSTER voc_annottype_pkey on mgd.VOC_AnnotType;
CLUSTER voc_annot_count_cache_pkey on mgd.VOC_Annot_Count_Cache;
CLUSTER voc_marker_cache_idx_clustered ON mgd.VOC_Marker_Cache;
CLUSTER voc_text_pkey on mgd.VOC_Text;
CLUSTER voc_vocabdag_pkey on mgd.VOC_VocabDAG;
CLUSTER voc_vocab_pkey on mgd.VOC_Vocab;

/* clustered indexes that are not on the primary key */

CLUSTER acc_accession_idx_clustered ON mgd.ACC_Accession;

CLUSTER all_allele_idx_clustered ON mgd.ALL_Allele;
CLUSTER all_cre_cache_idx_clustered ON mgd.ALL_Cre_Cache;
CLUSTER all_knockout_idx_clustered ON mgd.ALL_Knockout_Cache;
CLUSTER all_marker_assoc_idx_clustered ON mgd.ALL_Marker_Assoc;

CLUSTER bib_dataset_assoc_idx_clustered ON mgd.BIB_DataSet_Assoc;

CLUSTER crs_matrix_idx_clustered ON mgd.CRS_Matrix;

CLUSTER dag_closure_idx_clustered ON mgd.DAG_Closure;
CLUSTER dag_edge_idx_clustered ON mgd.DAG_Edge;
CLUSTER dag_node_idx_clustered ON mgd.DAG_Node;

CLUSTER gxd_allelepair_idx_clustered ON mgd.GXD_AllelePair;
CLUSTER gxd_antibodyalias_idx_clustered ON mgd.GXD_AntibodyAlias;
CLUSTER gxd_assay_idx_clustered ON mgd.GXD_Assay;
CLUSTER gxd_expression_idx_clustered ON mgd.GXD_Expression;
CLUSTER gxd_gelband_idx_clustered ON mgd.GXD_GelBand;
CLUSTER gxd_gellane_idx_clustered ON mgd.GXD_GelLane;
CLUSTER gxd_gelrow_idx_clustered ON mgd.GXD_GelRow;
CLUSTER gxd_index_idx_clustered ON mgd.GXD_Index;
CLUSTER gxd_specimen_idx_clustered ON mgd.GXD_Specimen;

CLUSTER hmd_homology_idx_clustered ON mgd.HMD_Homology;

CLUSTER img_cache_idx_clustered ON mgd.IMG_Cache;

CLUSTER mgi_note_idx_clustered ON mgd.MGI_Note;
CLUSTER mgi_reference_assoc_idx_clustered ON mgd.MGI_Reference_Assoc;
CLUSTER mgi_set_idx_clustered ON mgd.MGI_Set;

CLUSTER mrk_chromosome_idx_clustered ON mgd.MRK_Chromosome;
CLUSTER mrk_homology_cache_idx_clustered ON mgd.MRK_Homology_Cache;
CLUSTER mrk_label_idx_clustered ON mgd.MRK_Label;
CLUSTER mrk_location_cache_idx_clustered ON mgd.MRK_Location_Cache;
CLUSTER mrk_marker_idx_clustered ON mgd.MRK_Marker;
CLUSTER mrk_omim_cache_idx_clustered ON mgd.MRK_OMIM_Cache;

CLUSTER nom_marker_idx_clustered ON mgd.NOM_Marker;

CLUSTER prb_alias_idx_clustered ON mgd.PRB_Alias;
CLUSTER prb_allele_idx_clustered ON mgd.PRB_Allele;
CLUSTER prb_probe_idx_clustered ON mgd.PRB_Probe;
CLUSTER prb_rflv_idx_clustered ON mgd.PRB_RFLV;
CLUSTER prb_reference_idx_clustered ON mgd.PRB_Reference;
CLUSTER prb_source_idx_clustered ON mgd.PRB_Source;
CLUSTER prb_strain_genotype_idx_clustered ON mgd.PRB_Strain_Genotype;
CLUSTER prb_strain_marker_idx_clustered ON mgd.PRB_Strain_Marker;

CLUSTER seq_coord_cache_idx_clustered ON mgd.SEQ_Coord_Cache;
CLUSTER seq_marker_cache_idx_clustered ON mgd.SEQ_Marker_Cache;
CLUSTER seq_sequence_assoc_idx_clustered ON mgd.SEQ_Sequence_Assoc;
CLUSTER seq_sequence_idx_clustered ON mgd.SEQ_Sequence;
CLUSTER seq_source_assoc_idx_clustered ON mgd.SEQ_Source_Assoc;

CLUSTER voc_annotheader_idx_clustered ON mgd.VOC_AnnotHeader;
CLUSTER voc_annot_idx_clustered ON mgd.VOC_Annot;
CLUSTER voc_evidence_property_idx_clustered ON mgd.VOC_Evidence_Property;
CLUSTER voc_evidence_idx_clustered ON mgd.VOC_Evidence;
CLUSTER voc_go_cache_idx_clustered ON mgd.VOC_GO_Cache;
CLUSTER voc_term_idx_clustered ON mgd.VOC_Term;

CLUSTER wks_rosetta_idx_clustered ON mgd.WKS_Rosetta;

EOSQL
