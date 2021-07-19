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
 
${PG_MGD_DBSCHEMADIR}/trigger/ACC_Accession_drop.object  tee -a $LOG

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

with dups as (
select a._object_key
from acc_accession a
where a.prefixpart = 'J:'
group by _object_key having count(*) > 1
)
select a._accession_key, c._refs_key, a.accid, c.jnumid, c.mgiid, c.pubmedid, c.doiid, c.short_citation, u.login, r.creation_date
into temp table toDelete
from dups s, acc_accession a, bib_citation_cache c, bib_refs r, mgi_user u
where s._object_key = a._object_key
and a.prefixpart = 'J:'
and a._object_key = c._Refs_key
and c._refs_key = r._refs_key
and r._createdby_key = u._user_key
and a.accid != c.jnumid 
order by c.short_citation, c.jnumid
;

select * from toDelete;

delete from ACC_Accession
using toDelete
where toDelete._accession_key = acc_accession._accession_key
;

-- don't need to rebuild cache
--select * from BIB_reloadCache();

with dups as (
select a._object_key
from acc_accession a
where a.prefixpart = 'J:'
group by _object_key having count(*) > 1
)
select a._accession_key, c._refs_key, a.accid, c.jnumid, c.mgiid, c.pubmedid, c.doiid, c.short_citation, u.login, r.creation_date
into temp table toDelete
from dups s, acc_accession a, bib_citation_cache c, bib_refs r, mgi_user u
where s._object_key = a._object_key
and a.prefixpart = 'J:'
and a._object_key = c._Refs_key
and c._refs_key = r._refs_key
and r._createdby_key = u._user_key
and a.accid != c.jnumid 
order by c.short_citation, c.jnumid
;

EOSQL

${PG_MGD_DBSCHEMADIR}/trigger/ACC_Accession_create.object  tee -a $LOG

date |tee -a $LOG

