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
            pt.column_name as pk_column,
            c.constraint_name as constraint_name
        from information_schema.referential_constraints c
        inner join information_schema.table_constraints fk
            on c.constraint_name = fk.constraint_name
        inner join information_schema.table_constraints pk
            on c.unique_constraint_name = pk.constraint_name
        inner join information_schema.key_column_usage cu
            on c.constraint_name = cu.constraint_name
        inner join (select i1.table_name, i2.column_name
            from information_schema.table_constraints i1
        inner join information_schema.key_column_usage i2
            on i1.constraint_name = i2.constraint_name
        where lower(i1.constraint_type) = 'primary key') pt
            on pt.table_name = pk.table_name
order by pk.table_name, fk.table_name, cu.column_name
;

EOSQL

date |tee -a $LOG
