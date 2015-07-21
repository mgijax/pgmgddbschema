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
# mousecycload
#

cd `dirname $0` && . ../Configuration

cat - <<EOSQL | ${MGI_DBUTILS}/bin/doisql.csh ${MGD_DBSERVER} ${MGD_DBNAME} $0

/* GXD_GelBand contains _GelLane_key that does not exist in GXD_GelLane */
select b.* into #todelete1 from GXD_GelBand b 
where not exists (select 1 from GXD_GelLane g where b._GelLane_key = g._GelLane_key)
go
select * from #todelete1
go
delete GXD_GelBand from #todelete1 d
where d._GelLane_key = GXD_GelBand._GelLane_key
go

/* GXD_Index_Stages contains _Index_key that does not exist in GXD_Index */
select a.* into #todelete2 from GXD_Index_Stages a 
where not exists (select 1 from GXD_Index b where a._Index_key = b._Index_key)
go
select * from #todelete2
go
--delete GXD_Index_Stages from #todelete2 d
--where d._Index_key = GXD_Index_Stages._Index_key
--go

select a.* into #todelete4 from IMG_ImagePane a 
where not exists (select 1 from IMG_Image b where a._Image_key = b._Image_key)
go
select * from #todelete4
go
--delete IMG_ImagePane from #todelete4 d
--where d._ImagePane_key = IMG_ImagePane._ImagePane_key
--go

select a.* into #todelete5 from CRS_Cross a 
where not exists (select 1 from PRB_Strain b where a._malestrain_key = b._strain_key)
go
select * from #todelete5
go
/* do not run delete */

select a.* into #todelete6 from PRB_Strain_Genotype a 
where not exists (select 1 from PRB_Strain b where a._strain_key = b._strain_key)
go
select * from #todelete6
go
--delete PRB_Strain_Genotype from #todelete6 d
--where d._StrainGenotype_key = PRB_Strain_Genotype._StrainGenotype_key
--go

select a.* into #todelete7 from PRB_Source a 
where not exists (select 1 from PRB_Tissue b where a._Tissue_key = b._Tissue_key)
go
select * from #todelete7
go
--delete PRB_Source from #todelete7 d
--where d._Source_key = PRB_Source._Source_key
--go

select a.* into #todelete8 from VOC_Evidence a 
where not exists (select 1 from VOC_Annot b where a._Annot_key = b._Annot_key)
go
select * from #todelete8
go
--delete VOC_Evidence from #todelete8 d
--where d._AnnotEvidence_key = VOC_Evidence._AnnotEvidence_key
--go

/* MouseCyc loads DAG edges whose parent does not exist in DGA_Node */
/* this product needs to be looked at and fixed */
select e.* into #todelete9 from DAG_Edge e 
where not exists (select 1 from DAG_Node n where e._Parent_key = n._Node_key)
go
select * from #todelete9
go
--delete DAG_Edge from #todelete9 d
--where d._Edge_key = DAG_Edge._Edge_key
--go

EOSQL

