#!/bin/sh

# Count the number of create scripts for each type of object in the schema
# product and the number of objects that will be created by those scripts.

cd `dirname $0`
TOP=`pwd`
unset LC_ALL

echo "Object Type     Count"
echo "==============  ============"

cd ${TOP}/table
echo "Tables          `ls *_create.object | wc -l` scripts"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_catalog.pg_tables where schemaname = 'mgd'"

cd ${TOP}/index
echo "Indexes         `ls *_create.object | wc -l` scripts  (`grep -i '^create' *_create.object | wc -l` indexes)"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_stat_user_indexes where schemaname = 'mgd' and indexrelname not like '%_pkey'" 

cd ${TOP}/procedure
echo "Procedures      `ls *_create.object | wc -l` scripts (`grep -i '^CREATE OR REPLACE' *_create.object | wc -l` functios)"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "\df" | grep -i 'normal' | grep -i 'mgd' | wc -l

cd ${TOP}/trigger
echo "Triggers        `ls *_create.object | wc -l` scripts  (`grep -i '^create trigger ' *_create.object | wc -l` triggers)"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_catalog.pg_trigger where tgname like '%_trigger'" 

cd ${TOP}/view
echo "Views           `ls *_create.object | wc -l` scripts"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_catalog.pg_views where schemaname = 'mgd'" 

cd ${TOP}/key
echo "Primary Keys         `ls *_create.object | wc -l` scripts  (`grep -i 'ADD PRIMARY KEY' *_create.object | wc -l` primary keys)"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_stat_user_indexes where schemaname = 'mgd' and indexrelname like '%_pkey'" 

cd ${TOP}/key
echo "Foreign Keys            `ls *_create.object | wc -l` scripts  (`grep -i '^ALTER TABLE' *_create.object | grep -i 'FOREIGN KEY' | wc -l` foreign keys)"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(c.conname) from pg_constraint c join pg_namespace n on n.oid = c.connamespace where c.contype in ('f') and n.nspname = 'mgd'"

echo "Duplicate Primary/Foreign Keys"
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select c.conname as duplidateKeys from pg_constraint c join pg_namespace n on n.oid = c.connamespace where c.contype in ('f') and n.nspname = 'mgd' and c.conname like '%fkey1%'"

