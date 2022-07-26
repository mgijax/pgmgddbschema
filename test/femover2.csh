#!/bin/csh -f

if ( ${?MGICONFIG} == 0 ) then
        setenv MGICONFIG /usr/local/mgi/live/mgiconfig
endif

source ${MGICONFIG}/master.config.csh

setenv LOG $0.log
rm -rf $LOG
touch $LOG

date | tee -a $LOG
 
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

select pk.table_name as pk_table,
            fk.table_name as fk_table,
            cu.column_name as fk_column,
            pk.table_name as pk_table,
            i2.column_name as pk_column,
            c.constraint_name as constraint_name
        from information_schema.referential_constraints c,
             information_schema.table_constraints fk,
             information_schema.table_constraints pk,
             information_schema.key_column_usage cu,
             information_schema.table_constraints i1,
             information_schema.key_column_usage i2
        where c.constraint_name = fk.constraint_name
        and c.unique_constraint_name = pk.constraint_name
        and c.constraint_name = cu.constraint_name
        and pk.table_name = i1.table_name 
        and i1.constraint_name = i2.constraint_name
        and lower(i1.constraint_type) = 'primary key'
order by pk.table_name, fk.table_name, cu.column_name
;

EOSQL

date |tee -a $LOG
