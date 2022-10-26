#!/bin/csh -f

#
# mgd_java_api/prb/service/ProbeStrainService/validateStrainPrivate
#
# to use:  validateStrainPrivate.csh strainkey
#       validateStrainPrivate.csh 132375
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
 
setenv STRAINKEY $1

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
;

-- not checked
select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from ALL_Allele a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from PRB_Strain_Marker a where s._Strain_key = a._Strain_key)
;

-- checked

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from PRB_Strain_Genotype a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from ALL_CellLine a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from ALL_Variant a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from GXD_Genotype a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from MRK_StrainMarker a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from PRB_Allele_Strain a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from PRB_Source a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from CRS_Cross a where s._Strain_key = a._StrainHT_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from CRS_Cross a where s._Strain_key = a._StrainHO_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from CRS_Cross a where s._Strain_key = a._femaleStrain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from CRS_Cross a where s._Strain_key = a._maleStrain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from MLD_FISH a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from MLD_InSitu a where s._Strain_key = a._Strain_key)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from RI_RISet a where s._Strain_key = a._Strain_key_1)
;

select s._strain_key, s.strain, s.private from prb_strain s
where s._strain_key = $STRAINKEY
and exists (select 1 from RI_RISet a where s._Strain_key = a._Strain_key_2)
;



EOSQL

date |tee -a $LOG

