#!/bin/sh

#
# create 'trigger' scripts
#

cd `dirname $0` && . ../Configuration

#
# read thru triggers_delete.txt
#

#while IFS=: read object mgikey mgitype text
while IFS=: read object mgikey mgitype
do
echo $object
echo $mgikey
echo $mgitype
#echo $text

#cp ${MGD_DBSCHEMADIR}/trigger/${object}_create.object ${PG_MGD_DBSCHEMADIR}/trigger
cp ${PG_MGD_DBSCHEMADIR}/trigger/template_delete_create.object.new ${PG_MGD_DBSCHEMADIR}/trigger/${object}_delete_create.object
cp ${PG_MGD_DBSCHEMADIR}/trigger/template_delete_drop.object.new ${PG_MGD_DBSCHEMADIR}/trigger/${object}_delete_drop.object

ed ${PG_MGD_DBSCHEMADIR}/trigger/${object}_delete_create.object <<END
g/PG-TABLE/s//${object}/g
g/PG-KEY/s//${mgikey}/g
g/PG-TYPE/s//${mgitype}/g
.
w
q
END

ed ${PG_MGD_DBSCHEMADIR}/trigger/${object}_delete_drop.object <<END
g/PG-TABLE/s//${object}/g
g/PG-KEY/s//${mgikey}/g
g/PG-TYPE/s//${mgitype}/g
.
w
q
END

#
# execute the script to create the delete function/trigger
#
${PG_MGD_DBSCHEMADIR}/trigger/${object}_delete_create.object
${PG_MGD_DBSCHEMADIR}/trigger/${object}_insert_create.object

done < triggers_delete.txt

