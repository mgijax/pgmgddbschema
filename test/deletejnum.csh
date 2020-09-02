#!/bin/csh -f

#
# remove duplicate jnum
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
 
${PG_MGD_DBSCHEMADIR}/trigger/ACC_Accession_drop.object | tee -a $LOG

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0 | tee -a $LOG

delete from acc_accession where _accession_key in (1261819246, 1261819232, 1250989490, 1325950313, 1261985641)
;

EOSQL

${PG_MGD_DBSCHEMADIR}/trigger/ACC_Accession_create.object | tee -a $LOG

date |tee -a $LOG

