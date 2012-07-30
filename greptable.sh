#!/bin/sh

#
# grep the "product" for the "table"
#
# use the schema/table directory to find the list of tables
# 	greptable.sh /usr/local/mgi/live/femover
#
# or specifiy a single table
# 	greptable.sh /usr/local/mgi/live/femover GXD_StructureClosure
#

cd `dirname $0` && . ../Configuration

product=$1

if [ $# -eq 2 ]
then
    table=$2
else
    table=*_create.object
fi

#
# use mgddbschema/table/*_create.object to get list of tables
#
cd ${PG_MGD_DBSCHEMADIR}/table

for i in ${table}
do

t=`basename $i _create.object`

find ${product} | xargs grep ${t}

done

