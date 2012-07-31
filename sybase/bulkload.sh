#!/bin/sh

#
# exporter that uses the schema product
#

cd `dirname $0` && . ../Configuration

LOG=${EXPORTLOGS}/`basename $0`.log
rm -rf ${LOG}
touch ${LOG}

date >> ${LOG}

echo ${MGD_DBUSER} | tee -a ${LOG}
echo ${MGD_DBNAME} | tee -a ${LOG}
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

cd ${MGD_DBSCHEMADIR}/table

#
# bcp out the sybase data
#
if [ ${runBCP} -eq '1' ]
then
echo 'bcp out the files from sybase...' | tee -a ${LOG}
echo $$ > ${EXPORTLOGS}/$0.pid
for i in ${findObject}
do
i=`basename $i _create.object`
echo $i | tee -a ${LOG}
${MGI_DBUTILS}/bin/bcpout.csh ${MGD_DBSERVER} ${MGD_DBNAME} $i ${EXPORTDATA} $i.bcp | tee -a ${LOG}.${i}.bcp &
done
fi
#
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
echo "converting bcp using python regular expressions..." | tee -a ${LOG}
for i in ${findObject}
do
i=`basename $i _create.object`
${PG_MGD_DBSCHEMADIR}/sybase/textcleaner.sh ${EXPORTDATA} ${i} | tee -a ${LOG}.${i}.textcleaner &
done
fi
#
# wait until all jobs invoked above have terminated
wait
echo 'done: converting bcp using python regular expressions...' | tee -a ${LOG}
date | tee -a ${LOG}
#
# end: convert sybase data to postgres
#
exit 0

#
# if all tables, then run... 
#
if [ $runAll -eq '1' ]
then
echo 'drop database...' | tee -a ${LOG}
${PG_DBUTILS}/bin/dropDB.csh ${PG_DBSERVER} ${PG_DBNAME} | tee -a ${LOG}
echo 'create database...' | tee -a ${LOG}
${PG_DBUTILS}/bin/buildDB_be.csh ${PG_DBSERVER} ${PG_DBNAME} | tee -a ${LOG}
echo 'create tables...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/table/table_create.sh
fi

#
# one table
#

for i in ${findObject}
do

i=`basename $i _create.object`

if [ $runAll -eq '0' ]
then

echo "create table name...", $i | tee -a ${LOG}

echo "dropping indexes..." | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/index/${i}_drop.object

echo "dropping key..." | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/key/${i}_drop.object

#echo "dropping trigger..." | tee -a ${LOG}
#${PG_MGD_DBSCHEMADIR}/trigger/${i}_drop.object

echo "dropping/creating table..." | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/table/${i}_drop.object
${PG_MGD_DBSCHEMADIR}/table/${i}_create.object

fi

cd ${EXPORTDATA}

#
# copy data file into postgres
#
#
echo "calling postgres copy..." | tee -a ${LOG}
psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} <<END
\copy mgd.$i from '$i.bcp' with null as ''
\g
vacuum analyze mgd.$i;
END

#
# cleanup obsolete children
#
#echo "cleaning up obsolete children..." | tee -a ${LOG}
#${PG_MGD_DBSCHEMADIR}/sybase/cleanup.sh | tee -a ${LOG}

if [ $runAll -eq '0' ]
then

echo "adding indexes..." | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/index/${i}_create.object

echo "adding keys..." | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/key/${i}_create.object

#echo "adding trigger..." | tee -a ${LOG}
#${PG_MGD_DBSCHEMADIR}/trigger/${i}_create.object

fi

echo "#########" | tee -a ${LOG}

done

#
# if all tables, then run... 
#
if [ $runAll -eq '1' ]
then
echo 'run create key/index/trigger/view for all tables...' | tee -a ${LOG}
${PG_MGD_DBSCHEMADIR}/index/index_create.sh
${PG_MGD_DBSCHEMADIR}/key/key_create.sh
${PG_MGD_DBSCHEMADIR}/trigger/trigger_create.sh
${PG_MGD_DBSCHEMADIR}/view/view_create.sh
fi

#
# comments
#
#echo "updating comments..." | tee -a ${LOG}
#cd ${MGDPOSTGRES}/bin
#./comments.py
#psql -h ${PG_FE_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} < comments.txt

date | tee -a ${LOG}

