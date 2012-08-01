#!/bin/sh

#
# cluster all tables
#

cd `dirname $0` && . ./Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

CLUSTER mgd.ACC_Accession USING acc_accession_idx_clustered;
CLUSTER mgd.ACC_AccessionMax USING acc_accessionmax_pkey;
CLUSTER mgd.ACC_AccessionReference USING acc_accessionreference_pkey;
CLUSTER mgd.ACC_ActualDB USING acc_actualdb_pkey;
CLUSTER mgd.ACC_LogicalDB USING acc_logicaldb_pkey;
CLUSTER mgd.ACC_MGIType USING acc_mgitype_pkey;

CLUSTER mgd.ALL_Allele_CellLine USING all_allele_cellline_pkey;
CLUSTER mgd.ALL_Allele USING all_allele_idx_clustered;
CLUSTER mgd.ALL_Allele_Mutation USING all_allele_mutation_pkey;
CLUSTER mgd.ALL_CellLine USING all_cellline_pkey;
CLUSTER mgd.ALL_CellLine_Derivation USING all_cellline_derivation_pkey;
CLUSTER mgd.ALL_Cre_Cache USING all_cre_cache_idx_clustered;
CLUSTER mgd.ALL_Knockout_Cache USING all_knockout_cache_idx_clustered;
CLUSTER mgd.ALL_Label USING all_label_pkey;
CLUSTER mgd.ALL_Marker_Assoc USING all_marker_assoc_idx_clustered;

CLUSTER mgd.BIB_BOoks USING bib_books_pkey;
CLUSTER mgd.BIB_Citation_Cache USING bib_citation_cache_pkey;
CLUSTER mgd.BIB_DataSet_Assoc USING bib_dataset_assoc_idx_clustered;
CLUSTER mgd.BIB_DataSet USING bib_dataset_pkey;
CLUSTER mgd.BIB_Notes USING bib_notes_pkey;
CLUSTER mgd.BIB_Refs USING bib_refs_pkey;
CLUSTER mgd.BIB_ReviewStatus USING bib_reviewstatus_pkey;

CLUSTER mgd.CRS_Cross USING crs_cross_pkey;
CLUSTER mgd.CRS_Matrix USING crs_matrix_idx_clustered;
CLUSTER mgd.CRS_Progeny USING crs_progeny_pkey;
CLUSTER mgd.CRS_References USING crs_references_pkey;
CLUSTER mgd.CRS_Typings USING crs_typings_pkey;

CLUSTER mgd.DAG_Closure USING dag_closure_idx_clustered;
CLUSTER mgd.DAG_DAG USING dag_dag_pkey;
CLUSTER mgd.DAG_Edge USING dag_edge_idx_clustered;
CLUSTER mgd.DAG_Label USING dag_label_pkey;
CLUSTER mgd.DAG_Node USING dag_node_idx_clustered;

CLUSTER mgd.GO_Tracking USING go_tracking_pkey;

CLUSTER mgd.GXD_AlleleGenotype USING gxd_allelegenotype_pkey USING mgd.GXD_AlleleGenotype;
CLUSTER mgd.GXD_AllelePair USING gxd_allelepair_idx_clustered USING mgd.GXD_AllelePair;
CLUSTER mgd.GXD_Antibody USING gxd_antibody_pkey USING mgd.GXD_Antibody;
CLUSTER mgd.GXD_AntibodyAlias USING gxd_antibodyalias_idx_clustered USING mgd.GXD_AntibodyAlias;
CLUSTER mgd.GXD_AntibodyClass USING gxd_antibodyclass_pkey USING mgd.GXD_AntibodyClass;
CLUSTER mgd.GXD_AntibodyMarker USING gxd_antibodymarker_pkey USING mgd.GXD_AntibodyMarker;
CLUSTER mgd.GXD_AntibodyPrep USING gxd_antibodyprep_pkey USING mgd.GXD_AntibodyPrep;
CLUSTER mgd.GXD_AntibodyType USING gxd_antibodytype_pkey USING mgd.GXD_AntibodyType;
CLUSTER mgd.GXD_Antigen USING gxd_antigen_pkey USING mgd.GXD_Antigen;
CLUSTER mgd.GXD_Assay USING gxd_assay_idx_clustered USING mgd.GXD_Assay;
CLUSTER mgd.GXD_AssayNote USING gxd_assaynote_pkey USING mgd.GXD_AssayNote;
CLUSTER mgd.GXD_AssayType USING gxd_assaytype_pkey USING mgd.GXD_AssayType;
CLUSTER mgd.GXD_EmbeddingMethod USING gxd_embeddingmethod_pkey USING mgd.GXD_EmbeddingMethod;
CLUSTER mgd.GXD_Expression USING gxd_expression_idx_clustered USING mgd.GXD_Expression;
CLUSTER mgd.GXD_FixationMethod USING gxd_fixationmethod_pkey USING mgd.GXD_FixationMethod;
CLUSTER gxd_gelband_idx_clustered USING mgd.GXD_GelBand;
CLUSTER gxd_gelcontrol_pkey USING mgd.GXD_GelControl;
CLUSTER gxd_gellane_idx_clustered USING mgd.GXD_GelLane;
CLUSTER gxd_gellanestructure_pkey USING mgd.GXD_GelLaneStructure;
CLUSTER gxd_gelrnatype_pkey USING mgd.GXD_GelRNAType;
CLUSTER gxd_gelrow_idx_clustered USING mgd.GXD_GelRow;
CLUSTER gxd_gelunits_pkey USING mgd.GXD_GelUnits;
CLUSTER gxd_genotype_pkey USING mgd.GXD_Genotype;
CLUSTER gxd_index_idx_clustered USING mgd.GXD_Index;
CLUSTER gxd_index_stages_pkey USING mgd.GXD_Index_Stages;
CLUSTER gxd_insituresult_pkey USING mgd.GXD_InSituResult;
CLUSTER gxd_insituresultimage_pkey USING mgd.GXD_InSituResultImage;
CLUSTER gxd_isresultstructure_pkey USING mgd.GXD_ISResultStructure;
CLUSTER gxd_label_pkey USING mgd.GXD_Label;
CLUSTER gxd_pattern_pkey USING mgd.GXD_Pattern;
CLUSTER gxd_probeprep_pkey USING mgd.GXD_ProbePrep;
CLUSTER gxd_probesense_pkey USING mgd.GXD_ProbeSense;
CLUSTER gxd_secondary_pkey USING mgd.GXD_Secondary;
CLUSTER gxd_specimen_idx_clustered USING mgd.GXD_Specimen;
CLUSTER gxd_strength_pkey USING mgd.GXD_Strength;
CLUSTER gxd_structure_pkey USING mgd.GXD_Structure;
CLUSTER gxd_structureclosure_pkey USING mgd.GXD_StructureClosure;
CLUSTER gxd_structurename_pkey USING mgd.GXD_StructureName;
CLUSTER gxd_theilerstage_pkey USING mgd.GXD_TheilerStage;
CLUSTER gxd_visualizationmethod_pkey USING mgd.GXD_VisualizationMethod;

CLUSTER hmd_assay_pkey USING mgd.HMD_Assay;
CLUSTER hmd_class_pkey USING mgd.HMD_Class;
CLUSTER hmd_homology_assay_pkey USING mgd.HMD_Homology_Assay;
CLUSTER hmd_homology_idx_clustered USING mgd.HMD_Homology;
CLUSTER hmd_homology_marker_pkey USING mgd.HMD_Homology_Marker;
CLUSTER hmd_notes_pkey USING mgd.HMD_Notes;

CLUSTER img_cache_idx_clustered USING mgd.IMG_Cache;
CLUSTER img_image_pkey USING mgd.IMG_Image;
CLUSTER img_imagepane_assoc_pkey USING mgd.IMG_ImagePane_Assoc;
CLUSTER img_imagepane_pkey USING mgd.IMG_ImagePane;

CLUSTER map_coord_collection_pkey USING mgd.MAP_Coord_Collection;
CLUSTER map_coord_feature_pkey USING mgd.MAP_Coord_Feature;
CLUSTER map_coordinate_pkey USING mgd.MAP_Coordinate;

CLUSTER mgi_attributehistory_pkey USING mgd.MGI_AttributeHistory;
CLUSTER mgi_columns_pkey USING mgd.MGI_Columns;
CLUSTER mgi_measurement_pkey USING mgd.MGI_Measurement;
CLUSTER mgi_note_idx_clustered USING mgd.MGI_Note;
CLUSTER mgi_notechunk_pkey USING mgd.MGI_NoteChunk;
CLUSTER mgi_notetype_pkey USING mgd.MGI_NoteType;
CLUSTER mgi_organism_pkey USING mgd.MGI_Organism;
CLUSTER mgi_organism_mgitype_pkey USING mgd.MGI_Organism_MGIType;
CLUSTER mgi_refassoctype_pkey USING mgd.MGI_RefAssocType;
CLUSTER mgi_reference_assoc_idx_clustered USING mgd.MGI_Reference_Assoc;
CLUSTER mgi_roletask_pkey USING mgd.MGI_RoleTask;
CLUSTER mgi_set_idx_clustered USING mgd.MGI_Set;
CLUSTER mgi_setmember_pkey USING mgd.MGI_SetMember;
CLUSTER mgi_statistic_pkey USING mgd.MGI_Statistic;
CLUSTER mgi_statisticsql_pkey USING mgd.MGI_StatisticSql;
CLUSTER mgi_synonym_pkey USING mgd.MGI_Synonym;
CLUSTER mgi_synonymtype_pkey USING mgd.MGI_SynonymType;
CLUSTER mgi_tables_pkey USING mgd.MGI_Tables;
CLUSTER mgi_translation_pkey USING mgd.MGI_Translation;
CLUSTER mgi_translationtype_pkey USING mgd.MGI_TranslationType;
CLUSTER mgi_user_pkey USING mgd.MGI_User;
CLUSTER mgi_userrole_pkey USING mgd.MGI_UserRole;
CLUSTER mgi_vocassociation_pkey USING mgd.MGI_VocAssociation;
CLUSTER mgi_vocassociationtype_pkey USING mgd.MGI_VocAssociationType;

CLUSTER mlc_marker_pkey USING mgd.MLC_Marker;
CLUSTER mlc_reference_pkey USING mgd.MLC_Reference;
CLUSTER mlc_text_pkey USING mgd.MLC_Text;

CLUSTER mld_assay_types_pkey USING mgd.MLD_Assay_Types;
CLUSTER mld_concordance_pkey USING mgd.MLD_Concordance;
CLUSTER mld_contig_pkey USING mgd.MLD_Contig;
CLUSTER mld_contigprobe_pkey USING mgd.MLD_ContigProbe;
CLUSTER mld_distance_pkey USING mgd.MLD_Distance;
CLUSTER mld_expt_marker_pkey USING mgd.MLD_Expt_Marker;
CLUSTER mld_expt_notes_pkey USING mgd.MLD_Expt_Notes;
CLUSTER mld_expts_pkey USING mgd.MLD_Expts;
CLUSTER mld_fish_pkey USING mgd.MLD_FISH;
CLUSTER mld_fish_region_pkey USING mgd.MLD_FISH_Region;
CLUSTER mld_hit_pkey USING mgd.MLD_Hit;
CLUSTER mld_hybrid_pkey USING mgd.MLD_Hybrid;
CLUSTER mld_insitu_pkey USING mgd.MLD_InSitu;
CLUSTER mld_isregion_pkey USING mgd.MLD_ISRegion;
CLUSTER mld_matrix_pkey USING mgd.MLD_Matrix;
CLUSTER mld_mc2point_pkey USING mgd.MLD_MC2point;
CLUSTER mld_mcdatalist_pkey USING mgd.MLD_MCDataList;
CLUSTER mld_notes_pkey USING mgd.MLD_Notes;
CLUSTER mld_physmap_pkey USING mgd.MLD_PhysMap;
CLUSTER mld_ri2point_pkey USING mgd.MLD_RI2Point;
CLUSTER mld_ri_pkey USING mgd.MLD_RI;
CLUSTER mld_ridata_pkey USING mgd.MLD_RIData;
CLUSTER mld_statistics_pkey USING mgd.MLD_Statistics;

CLUSTER mrk_alias_pkey USING mgd.MRK_Alias;
CLUSTER mrk_anchors_pkey USING mgd.MRK_Anchors;
CLUSTER mrk_chromosome_idx_clustered USING mgd.MRK_Chromosome;
CLUSTER mrk_class_pkey USING mgd.MRK_Class;
CLUSTER mrk_classes_pkey USING mgd.MRK_Classes;
CLUSTER mrk_current_pkey USING mgd.MRK_Current;
CLUSTER mrk_event_pkey USING mgd.MRK_Event;
CLUSTER mrk_eventreason_pkey USING mgd.MRK_EventReason;
CLUSTER mrk_history_pkey USING mgd.MRK_History;
CLUSTER mrk_homology_cache_idx_clustered USING mgd.MRK_Homology_Cache;
CLUSTER mrk_label_idx_clustered USING mgd.MRK_Label;
CLUSTER mrk_location_cache_idx_clustered USING mgd.MRK_Location_Cache;
CLUSTER mrk_marker_idx_clustered USING mgd.MRK_Marker;
CLUSTER mrk_mcv_cache_pkey USING mgd.MRK_MCV_Cache;
CLUSTER mrk_mcv_count_cache_pkey USING mgd.MRK_MCV_Count_Cache;
CLUSTER mrk_notes_pkey USING mgd.MRK_Notes;
CLUSTER mrk_offset_pkey USING mgd.MRK_Offset;
CLUSTER mrk_omim_cache_idx_clustered USING mgd.MRK_OMIM_Cache;
CLUSTER mrk_reference_pkey USING mgd.MRK_Reference;
CLUSTER mrk_status_pkey USING mgd.MRK_Status;
CLUSTER mrk_types_pkey USING mgd.MRK_Types;

CLUSTER nom_marker_idx_clustered USING mgd.NOM_Marker;

CLUSTER prb_alias_idx_clustered USING mgd.PRB_Alias;
CLUSTER prb_allele_idx_clustered USING mgd.PRB_Allele;
CLUSTER prb_allele_strain_pkey USING mgd.PRB_Allele_Strain;
CLUSTER prb_marker_pkey USING mgd.PRB_Marker;
CLUSTER prb_notes_pkey USING mgd.PRB_Notes;
CLUSTER prb_probe_idx_clustered USING mgd.PRB_Probe;
CLUSTER prb_ref_notes_pkey USING mgd.PRB_Ref_Notes;
CLUSTER prb_reference_idx_clustered USING mgd.PRB_Reference;
CLUSTER prb_rflv_idx_clustered USING mgd.PRB_RFLV;
CLUSTER prb_source_idx_clustered USING mgd.PRB_Source;
CLUSTER prb_strain_pkey USING mgd.PRB_Strain;
CLUSTER prb_strain_genotype_idx_clustered USING mgd.PRB_Strain_Genotype;
CLUSTER prb_strain_marker_idx_clustered USING mgd.PRB_Strain_Marker;
CLUSTER prb_tissue_pkey USING mgd.PRB_Tissue;

CLUSTER ri_riset_pkey USING mgd.RI_RISet;
CLUSTER ri_summary_pkey USING mgd.RI_Summary;
CLUSTER ri_summary_expt_ref_pkey USING mgd.RI_Summary_Expt_Ref;

CLUSTER seq_allele_assoc_pkey USING mgd.SEQ_Allele_Assoc;
CLUSTER seq_coord_cache_idx_clustered USING mgd.SEQ_Coord_Cache;
CLUSTER seq_description_cache_pkey USING mgd.SEQ_Description_Cache;
CLUSTER seq_genemodel_pkey USING mgd.SEQ_GeneModel;
CLUSTER seq_genetrap_pkey USING mgd.SEQ_GeneTrap;
CLUSTER seq_marker_cache_idx_clustered USING mgd.SEQ_Marker_Cache;
CLUSTER seq_probe_cache_pkey USING mgd.SEQ_Probe_Cache;
CLUSTER seq_sequence_assoc_idx_clustered USING mgd.SEQ_Sequence_Assoc;
CLUSTER seq_sequence_idx_clustered USING mgd.SEQ_Sequence;
CLUSTER seq_sequence_raw_pkey USING mgd.SEQ_Sequence_Raw;
CLUSTER seq_source_assoc_idx_clustered USING mgd.SEQ_Source_Assoc;

CLUSTER voc_allele_cache_pkey USING mgd.VOC_Allele_Cache;
CLUSTER voc_annot_count_cache_pkey USING mgd.VOC_Annot_Count_Cache;
CLUSTER voc_annot_idx_clustered USING mgd.VOC_Annot;
CLUSTER voc_annotheader_idx_clustered USING mgd.VOC_AnnotHeader;
CLUSTER voc_annottype_pkey USING mgd.VOC_AnnotType;
CLUSTER voc_evidence_idx_clustered USING mgd.VOC_Evidence;
CLUSTER voc_evidence_property_idx_clustered USING mgd.VOC_Evidence_Property;
CLUSTER voc_go_cache_idx_clustered USING mgd.VOC_GO_Cache;
CLUSTER voc_marker_cache_pkey USING mgd.VOC_Marker_Cache;
CLUSTER voc_term_idx_clustered USING mgd.VOC_Term;
CLUSTER voc_text_pkey USING mgd.VOC_Text;
CLUSTER voc_vocab_pkey USING mgd.VOC_Vocab;
CLUSTER voc_vocabdag_pkey USING mgd.VOC_VocabDAG;

CLUSTER wks_rosetta_idx_clustered USING mgd.WKS_Rosetta;

EOSQL
