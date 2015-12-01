#!/bin/sh

cd `dirname $0` && . ../Configuration

#
# comments
#
echo "updating comments..." | tee -a ${LOG}
./comments.py
chmod 775 ${PG_MGD_DBSCHEMADIR}/comments/*object
#psql -U ${PG_DBUSER} -d ${PG_DBNAME} < comments.txt

