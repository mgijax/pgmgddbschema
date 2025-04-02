#!/bin/csh -f

#
#

cd `dirname $0`

echo "Clean up ${MGD_DBSERVER}.${MGD_DBNAME}.MGI_Note"
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

select * from MGI_Note where note like E'%gender%';
select * from MLD_Expt_Notes where note like E'%gender%';
select * from VOC_Term where note like E'%gender%';
select * from BIB_Notes where note like E'%gender%';
select * from CRS_Matrix where notes like E'%gender%';
select * from CRS_Progeny where notes like E'%gender%';
select * from GXD_HTSample_RNASeqSet where note like E'%gender%';
select * from MLD_Notes where note like E'%gender%';
select * from MRK_DO_Cache where headerFootnote like E'%gender%';
select * from MRK_DO_Cache where genotypeFootnote like E'%gender%';
select * from PRB_Notes where note like E'%gender%';
select * from PRB_Ref_Notes where note like E'%gender%';

select * from GXD_Antibody where antibodyNote like E'%gender%';
select * from GXD_Antigen where antigenNote like E'%gender%';
select * from GXD_AssayNote where assayNote like E'%gender%';
select * from GXD_Expression where resultNote like E'%gender%';
select * from GXD_GelBand where bandNote like E'%gender%';

select * from GXD_GelLane where ageNote like E'%gender%';
select * from GXD_GelLane where laneNote like E'%gender%';
select * from GXD_GelRow where rowNote like E'%gender%';
select * from GXD_InSituResult where resultNote  like E'%gender%';
select * from GXD_Specimen where ageNote  like E'%gender%';
select * from GXD_Specimen where specimenNote like E'%gender%';

--update MGI_Note set note=replace(note,E'gender','sex') where note like E'%gender%';
--update MLD_Expt_Notes set note=replace(note,E'gender','sex') where note like E'%gender%';
--update VOC_Term set note=replace(note,E'gender','sex') where note like E'%gender%';

--select * from MGI_Note where note like E'%gender%';
--select * from MLD_Expt_Notes where note like E'%gender%';

EOSQL

exit 0
