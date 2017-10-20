#!/bin/sh

#
# purpose:
#
# verify that bib_workflow_status makes sense
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee $0.log

--
-- AP
--

select distinct 'AP/Indexed', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from MGI_Reference_Assoc gi where gi._Refs_key = r._Refs_key and gi._MGIType_key = 11)
and not exists (select 1 from VOC_Evidence e, VOC_Annot a
        where e._Refs_key = r._Refs_key
        and e._Annot_key = a._Annot_key
        and a._AnnotType_key = 1002)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576664
and s._Status_key != 31576673
and s.isCurrent = 1
;

select distinct 'AP/Full-coded', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from VOC_Evidence e, VOC_Annot a
     where e._Refs_key = r._Refs_key
     and e._Annot_key = a._Annot_key
     and a._AnnotType_key = 1002)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576664
and s._Status_key != 31576674
and s.isCurrent = 1
;

--
-- GXD
--

select distinct 'GXD/Indexed', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from GXD_Index gi where gi._Refs_key = r._Refs_key)
and not exists (select 1 from GXD_Assay ga where ga._Refs_key = r._Refs_key)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576665
and s._Status_key != 31576673
and s.isCurrent = 1
;

select distinct 'GXD/Full-coded', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from GXD_Assay ga where ga._Refs_key = r._Refs_key)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576665
and s._Status_key != 31576674
and s.isCurrent = 1
;

--
-- GO
--

select distinct 'GO/Indexed', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from BIB_DataSet_Assoc dbsa
	where dbsa._DataSet_key in (1005)
	and dbsa._Refs_key = r._Refs_key
	and dbsa.isNeverUsed = 0
	)
and not exists (select 1 from VOC_Evidence e, VOC_Annot a
        where e._Refs_key = r._Refs_key
        and e._Annot_key = a._Annot_key
        and a._AnnotType_key = 1000)
and exists (select 1 from MGI_Reference_Assoc gi where gi._Refs_key = r._Refs_key and gi._MGIType_key = 2)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576666
and s._Status_key != 31576673
and s.isCurrent = 1
;


select distinct 'GO/Full-coded', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from VOC_Evidence e, VOC_Annot a
      where e._Refs_key = r._Refs_key
      and e._Annot_key = a._Annot_key
      and a._AnnotType_key = 1000)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576666
and s._Status_key != 31576674
and s.isCurrent = 1
;

--
-- QTL
--

select distinct 'QTL/Indexed', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where not exists (select 1 from MLD_Expts gi where gi._Refs_key = r._Refs_key
    and gi.exptType in ('TEXT', 'TEXT-QTL', 'TEXT-QTL-Candidate Genes', 'TEXT-Congenic', 'TEXT-Meta Analysis'))
and exists (select 1 from MRK_Reference gi, MRK_Marker m
    where gi._Refs_key = r._Refs_key
    and gi._Marker_key = m._Marker_key
    and m._Marker_Type_key = 6)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576668
and s._Status_key != 31576673
and s.isCurrent = 1
;

select distinct 'QTL/Full-coded', r._Refs_key, r.jnumID, g.term, t.term
from BIB_Citation_Cache r, BIB_Workflow_Status s, VOC_Term g, VOC_Term t
where exists (select 1 from MLD_Expts gi where gi._Refs_key = r._Refs_key
    and gi.exptType in ('TEXT', 'TEXT-QTL', 'TEXT-QTL-Candidate Genes', 'TEXT-Congenic', 'TEXT-Meta Analysis'))
and exists (select 1 from MLD_Expts gi, MLD_Expt_Marker mi, MRK_Marker m
    where gi._Refs_key = r._Refs_key
    and gi._Expt_key = mi._Expt_key
    and mi._Marker_key = m._Marker_key
    and m._Marker_Type_key = 6)
and r._Refs_key = s._Refs_key
and s._Group_key = g._Term_key
and s._Status_key = t._Term_key
and s._Group_key = 31576668
and s._Status_key != 31576674
and s.isCurrent = 1

EOSQL

date |tee -a $LOG

