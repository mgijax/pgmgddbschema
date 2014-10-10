#!/bin/sh

#
# exporter that uses the schema product
#
# tables : 204
# indexes : 750
#
# tables : 206 (txt_ tables)
# indexes : 765 (lower = 11 + 7 = 18) = 747
#

cd `dirname $0` && . ../Configuration

LOG=${EXPORTLOGS}/`basename $0`.log
rm -rf ${LOG}
touch ${LOG}

rm -rf ${PG_MGD_DBSCHEMADIR}/logs/*/*

date >> ${LOG}

echo 'from (Sybase)...'
echo ${MGD_DBUSER} | tee -a ${LOG}
echo ${MGD_DBNAME} | tee -a ${LOG}

echo 'to (Posgres)...'
echo ${PG_DBSERVER} | tee -a ${LOG}
echo ${PG_DBUSER} | tee -a ${LOG}
echo ${PG_DBNAME} | tee -a ${LOG}

#
# run exporter for all tables or just one table
#
if [ $# -eq 1 ]
then
    findObject=$1
    runAll=0
else
    findObject=*_create.object
    runAll=1
fi

#
# sybase:  bcp out the mgd data files
#

#
# bcp out the sybase data
#
if [ ${runBCP} -eq '1' ]
then
echo $$ > ${EXPORTLOGS}/$0.pid
cd ${MGD_DBSCHEMADIR}/table
for i in ${findObject}
do
i=`basename $i _create.object`
echo 'bcp out the files from sybase...', ${i} | tee -a ${LOG}
echo $i | tee -a ${LOG}
${MGI_DBUTILS}/bin/bcpout.csh ${MGD_DBSERVER} ${MGD_DBNAME} $i ${EXPORTDATA} $i.bcp | tee -a ${LOG}.${i}.bcp &
done
fi
# wait until all jobs invoked above have terminated
wait
echo 'done: bcp out the files from sybase...' | tee -a ${LOG}
date | tee -a ${LOG}
#
# end: bcp out the sybase data
#

#
# convert sybase data to postgres format
#
if [ ${runBCP} -eq '1' ]
then
cd ${MGD_DBSCHEMADIR}/table
for i in ${findObject}
do
i=`basename $i _create.object`
echo 'converting bcp using python regular expressions...', ${i} | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/sybase/textcleaner.sh ${EXPORTDATA} ${i} | tee -a ${LOG}.${i}.textcleaner
done
fi
# wait until all jobs invoked above have terminated
wait
echo 'done: converting bcp using python regular expressions...' | tee -a ${LOG}
date | tee -a ${LOG}
#
# end: convert sybase data to postgres
#

#
# all tables
#
if [ $runAll -eq '1' ]
then

echo 'drop database...' | tee -a ${LOG}
${PG_DBUTILS}/bin/dropSchema.csh ${PG_DBSERVER} ${PG_DBNAME} mgd | tee -a ${LOG}
echo 'create schema for 'mgd'...' | tee -a ${LOG}
${PG_DBUTILS}/bin/createSchema.csh ${PG_DBSERVER} ${PG_DBNAME} mgd | tee -a ${LOG}
echo 'create tables for 'mgd'...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/table/table_create.sh

else
#
# one table
#

i=`basename ${findObject} _create.object`

echo 'create table name...', $i | tee -a ${LOG}

echo 'dropping indexes...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/index/${i}_drop.object

echo 'dropping key...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/key/${i}_drop.object

#echo 'dropping trigger...' | tee -a ${LOG}
#${PG_MGD_DBSCHEMADIR}/trigger/${i}_drop.object

echo 'dropping/creating table...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/table/${i}_drop.object
${PG_MGD_DBSCHEMADIR}/table/${i}_create.object

fi

#
# copy data file into postgres
#
cd ${MGD_DBSCHEMADIR}/table
echo 'calling postgres copy...' | tee -a ${LOG}
counter=0

for i in ${findObject}
do

i=`basename ${i} _create.object`

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "\copy mgd.$i from '${EXPORTDATA}/${i}.new' with null as ''" | tee -a ${LOG}.${i}.copy &

counter=`expr $counter + 1`

#
# if counter > counterMax, then wait
#
if [ ${counter} -gt ${counterMax} ]
then
    echo 'waiting for background copies to be completed...'
    wait
    counter=1
fi

done
# wait until all jobs invoked above have terminated
wait

echo 'done: calling postgres copy...' | tee -a ${LOG}
date | tee -a ${LOG}

#
# cleanup obsolete children
#
#echo 'cleaning up obsolete children...' | tee -a ${LOG}
#${PG_MGD_DBSCHEMADIR}/sybase/cleanup.sh | tee -a ${LOG}

#
# indexes/keys/triggers/views
#

#
# all tables
#
if [ $runAll -eq '1' ]
then
echo 'run create key for all tables...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/key/key_create.sh
echo 'run create index for all tables...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/index/index_create.sh
echo 'run create trigger for all tables...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/trigger/trigger_create.sh
echo 'run create view for all tables...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/view/view_create.sh
echo 'run create comments for all tables...' | tee -a ${LOG}
${EXPORTER}/bin/commentsPostgres.py

else
#
# one table
#

i=`basename ${findObject} _create.object`

echo 'adding indexes...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/index/${i}_create.object

echo 'adding keys...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/key/${i}_create.object

if [ -f ${PG_MGD_DBSCHEMADIR}/trigger/${i}_delete_create.object ]
then
	echo 'adding delete trigger...' | tee -a ${LOG}
	${PG_MGD_DBSCHEMADIR}/trigger/${i}_delete_create.object
fi

if [ -f ${PG_MGD_DBSCHEMADIR}/trigger/${i}_insert_create.object ]
then
	echo 'adding insert trigger...' | tee -a ${LOG}
	${PG_MGD_DBSCHEMADIR}/trigger/${i}_insert_create.object
fi

fi

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_stat_user_tables where schemaname = 'mgd'" | tee -a ${LOG}

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} --command "select count(*) from pg_stat_user_indexes where schemaname = 'mgd'" | tee -a ${LOG}

grep "psql:" ${PG_MGD_DBSCHEMADIR}/logs/*/*create.object.log | tee -a ${LOG}

date | tee -a ${LOG}

