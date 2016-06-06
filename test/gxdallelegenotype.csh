#!/bin/sh

#
# truncates GXD_AlleleGentoype (cache)
# re-loads entire cache
# if final count is (0), then cache is full/done
#
# set is limited to 1000 rows at a time 
# because GXD_orderGentoypes will run out of memory
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0
DROP FUNCTION IF EXISTS GXD_orderGenotypesAll_reload();
TRUNCATE TABLE GXD_AlleleGenotype;
EOSQL

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

CREATE OR REPLACE FUNCTION GXD_orderGenotypesAll_reload (
)
RETURNS VOID AS
\$\$

DECLARE
v_alleleKey int;

BEGIN

FOR v_alleleKey IN
SELECT DISTINCT _Allele_key_1
FROM GXD_AllelePair a
WHERE not exists
(SELECT 1 FROM GXD_AlleleGenotype g
WHERE a._Genotype_key = g._Genotype_key
AND a._Allele_key_1 = g._Allele_key)
UNION
SELECT DISTINCT _Allele_key_2
FROM GXD_AllelePair a
WHERE a._Allele_key_2 IS NOT NULL
AND NOT EXISTS
(SELECT 1 FROM GXD_AlleleGenotype g
WHERE a._Genotype_key = g._Genotype_key
AND a._Allele_key_2 = g._Allele_key)
LIMIT 1000
LOOP
        PERFORM GXD_orderGenotypes (v_alleleKey);
END LOOP;

END;
\$\$
LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION GXD_orderGenotypesAll_reload() TO public;

COMMENT ON FUNCTION mgd.GXD_orderGenotypesAll_reload() IS 'refresh the gxd_allelegenotype (cache) for all genotypes';

EOSQL

for i in {1..50}
do
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0
select GXD_orderGenotypesAll_reload();
select count(*) from gxd_allelegenotype;
SELECT count(_Genotype_key)
FROM GXD_Genotype g
WHERE NOT EXISTS (SELECT 1 FROM GXD_AlleleGenotype a where g._Genotype_key = a._Genotype_key)
AND EXISTS (SELECT 1 FROM GXD_AllelePair ap where g._Genotype_key = ap._Genotype_key)
;
EOSQL
done

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0
DROP FUNCTION IF EXISTS GXD_orderGenotypesAll_reload();
EOSQL

date | tee -a $LOG

