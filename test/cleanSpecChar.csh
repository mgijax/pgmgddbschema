#!/bin/csh -f

#
# This script will clean up special characters in the note field of the MGI_Note table.
#
# 10/04/2021 : not needed any more.
# This is all handled by API or individual loads.
#

cd `dirname $0`

echo "Clean up ${MGD_DBSERVER}.${MGD_DBNAME}.MGI_Note"
cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0

select * from MGI_Note where note like E'%\r%';

update MGI_Note set note=replace(note,E'\r','') where note like E'%\r%';

select * from MGI_Note where note like E'%\r%';

EOSQL

exit 0
