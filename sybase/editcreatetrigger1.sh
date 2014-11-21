#!/bin/sh

#
# create 'trigger' scripts
#

cd `dirname $0` && . ../Configuration

#
# read thru triggers_deletion.txt
#

while IFS=: read object mgikey mginame
do
echo $object
echo $mgikey
echo $mginame

#cp ${MGD_DBSCHEMADIR}/trigger/${object}_create.object ${PG_MGD_DBSCHEMADIR}/trigger
cp ${PG_MGD_DBSCHEMADIR}/trigger/template_insert1_create.object.new ${PG_MGD_DBSCHEMADIR}/trigger/${object}_insert_create.object
cp ${PG_MGD_DBSCHEMADIR}/trigger/template_insert_drop.object.new ${PG_MGD_DBSCHEMADIR}/trigger/${object}_insert_drop.object

ed ${PG_MGD_DBSCHEMADIR}/trigger/${object}_insert_create.object <<END
g/PG-TABLE/s//${object}/g
g/PG-KEY/s//${mgikey}/g
g/PG-NAME/s//${mginame}/g
.
w
q
END

ed ${PG_MGD_DBSCHEMADIR}/trigger/${object}_insert_drop.object <<END
g/PG-TABLE/s//${object}/g
.
w
q
END

#
# execute the script to create the delete function/trigger
#
${PG_MGD_DBSCHEMADIR}/trigger/${object}_insert_create.object

done < triggers_insert1.txt

