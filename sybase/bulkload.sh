#!/bin/sh

#
# exporter that uses the schema product
#

cd `dirname $0` && . ../Configuration

LOG=${EXPORTLOGS}/`basename $0`.log
rm -rf ${LOG}
touch ${LOG}

date >> ${LOG}

echo ${MGD_DBUSER}
echo ${MGD_DBNAME}
echo ${PG_MGD_DBUSER}
echo ${PG_MGD_DBNAME}

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
# if all tables, then run... 
#
if [ $runAll -eq '1' ]
then
echo 'drop database...' | tee -a ${LOG}
${PG_DBUTILS}/bin/dropDB.csh ${PG_DBSERVER} ${PG_DBNAME}
fi

#
# else run script by object (see below)
#

#
# bcp out the sybase data
#
if [ ${runBCP} -eq '1' ]
then
echo 'bcp out the files from sybase...' | tee -a ${LOG}
for i in ${findObject}
do
i=`basename $i _create.object`
echo $i | tee -a ${LOG}
${MGI_DBUTILS}/bin/bcpout.csh ${MGD_DBSERVER} ${MGD_DBNAME} $i ${EXPORTDATA} $i.bcp
done
fi
#
# end: bcp out the sybase data
#

#
# migrate bcp data format and load into postgres
#

for i in ${findObject}
do

i=`basename $i _create.object`

echo "table name...", $i | tee -a ${LOG}

if [ $runAll -eq '0' ]
then
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
# convert sybase data to postgres
#
if [ ${runBCP} -eq '1' ]
then

echo "converting bcp using python regular expressions..." | tee -a ${LOG}
# exporter scrip
cat $i.bcp | ${EXPORTER}/bin/postgresTextCleaner.py > $i.new
rm $i.bcp
mv $i.new $i.bcp

echo "converting bcp using perl #1..." | tee -a ${LOG}
/usr/local/bin/perl -p -i -e 's/&=&/\t/g' $i.bcp

echo "converting bcp using perl #2..." | tee -a ${LOG}
/usr/local/bin/perl -p -i -e 's/\t(... {1,2}\d{1,2} \d{4} {1,2}\d{1,2}:\d\d:\d\d):(.{5})/\t\1.\2/g' $i.bcp

echo "converting bcp using perl #3..." | tee -a ${LOG}
/usr/local/bin/perl -p -i -e 's/#=#//g' $i.bcp

fi
#
# end: convert sybase data to postgres
#

#
# copy data file into postgres
#
#vacuum analyze mgd.$i;
#
echo "calling postgres copy..." | tee -a ${LOG}
psql -U ${PG_MGD_DBUSER} -d ${PG_MGD_DBNAME} <<END 
\copy mgd.$i from '$i.bcp' with null as ''
\g
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
#psql -U ${MGD_DBUSER} -d ${MGD_DBNAME} < comments.txt

date | tee -a ${LOG}

