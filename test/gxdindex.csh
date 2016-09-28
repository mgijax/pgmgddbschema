#!/bin/sh

#
# GXD_Index
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select * from VOC_Term where _Vocab_key = 11;
select * from VOC_Term where _Vocab_key = 74;

--
-- update
-- J:12603  
-- change Priority from 'High' (74714) to 'Low' (74716)
-- change Conidtional from 'Not Specified' (4834243) to 'Not Applicable' (4834242)
--

select i.*
from BIB_Citation_Cache r, GXD_Index i
where r.jnumID in ('J:12603')
and r._Refs_key = i._Refs_key
;

update GXD_Index 
set _priority_key = 74716, _conditionalmutants_key = 4834242
where _Index_key = 1327;

select i.*
from BIB_Citation_Cache r, GXD_Index i
where r.jnumID in ('J:12603')
and r._Refs_key = i._Refs_key
;

update GXD_Index 
set _priority_key = 74714, _conditionalmutants_key = 4834243
where _Index_key = 1327;

select i.*
from BIB_Citation_Cache r, GXD_Index i
where r.jnumID in ('J:12603')
and r._Refs_key = i._Refs_key
;

--
-- add
-- J:12603 (12567)
-- Zan (27555)
--

select i.*
from BIB_Citation_Cache r, GXD_Index i
where r.jnumID in ('J:12603')
and r._Refs_key = i._Refs_key
and i._Marker_key = 27555
;

insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
	12567, 27555, null, null, null, 1000, 1000, now(), now())
;	

select i.*
from BIB_Citation_Cache r, GXD_Index i
where r.jnumID in ('J:12603')
and r._Refs_key = i._Refs_key
and i._Marker_key = 27555
;

delete from GXD_Index where _Index_key = (select max(_Index_key) from GXD_Index) 
and _Refs_key = 12567
and _Marker_key = 27555
;

--
-- add
-- J:1 (75786)
-- Zan (12180)
-- Zan (12181)
--

select r.*
from BIB_Citation_Cache r
where r.jnumID in ('J:1')
and not exists (select 1 from GXD_Index i where r._Refs_key = i._Refs_key)
;

-- should raise exception
insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
	75786, 12180, null, null, null, 1000, 1000, now(), now())
;	

-- should work and use default conditional
insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
	75786, 12180, 74714, null, null, 1000, 1000, now(), now())
;	

select i.*
from BIB_Citation_Cache r, GXD_Index i
where r.jnumID in ('J:1')
and r._Refs_key = i._Refs_key
;

delete from GXD_Index where _Refs_key = 75786;
;

EOSQL

date | tee -a $LOG

