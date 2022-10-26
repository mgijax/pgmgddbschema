#!/bin/csh -f

#
# find ascii characters and replace with '' (nothing)
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

select a.accID, r._result_key, s.specimenLabel, regexp_replace(r.resultnote, '([^[:ascii:]])', '', 'g') as markerd_up
from gxd_insituresult r, gxd_specimen s, acc_accession a
where r.resultnote ~ '[^[:ascii:]]'
and r._specimen_key = s._specimen_key
and s._assay_key = a._object_key
and a._mgitype_key = 8
;

select a.accID, r._result_key, s.specimenLabel, r.resultnote
from gxd_insituresult r, gxd_specimen s, acc_accession a
where r.resultnote like E'\\x01%'
and r._specimen_key = s._specimen_key
and s._assay_key = a._object_key
and a._mgitype_key = 8
;

--GXD_Index
select a.mgiID, a.jnumid, r._index_key, r._refs_key, r.comments, r.creation_date
from gxd_index r, bib_citation_cache a
where r.comments like E'\\x01%'
and r._refs_key = a._refs_key
order by r.creation_date, a.jnumid
;

--BIB_Notes
select a.mgiID, a.jnumid, r._refs_key, r.note
from bib_notes r, bib_citation_cache a
where r.note like E'\\x01%'
and r._refs_key = a._refs_key
order by a.jnumid
;

--GXD_Genotype
select a.accID, r._genotype_key, concat(ps.strain,',',m.symbol) as genotypeDisplay
from gxd_genotype r, prb_strain ps, gxd_allelegenotype ap, mrk_marker m, acc_accession a
where r.note like E'\\x01%'
and r._genotype_key = a._object_key
and a._logicaldb_key = 1
and a._mgitype_key = 12
and r._strain_key = ps._strain_key
and r._genotype_key = ap._genotype_key
and ap._marker_key = m._marker_key
;

--PRB_Ref_Notes
select a.accID, p._probe_key, p.name, pn.note
from prb_probe p, prb_reference r, prb_ref_notes pn, acc_accession a
where pn.note like E'\\x01%'
and p._probe_key = a._object_key
and a._logicaldb_key = 1
and a._mgitype_key = 3
and p._probe_key = r._probe_key
and r._reference_key = pn._reference_key
and exists (select 1 from prb_notes nn where p._probe_key = nn._probe_key)
;

--PRB_Notes
select a.accID, p._probe_key, p.name, pn.note
from prb_probe p, prb_notes pn, acc_accession a
where (pn.note like E'\\x01%' or pn.note ~ '[^[:ascii:]]')
and p._probe_key = a._object_key
and a._logicaldb_key = 1
and a._mgitype_key = 3
and p._probe_key = pn._probe_key
;

--VOC_Term
select v.*
from voc_term v
where v.note like E'\\x01%'
;

--GXD_HTSample_RNASeqSet

--MLD_Expt_Notes

--MLD_Notes

EOSQL

date |tee -a $LOG
