#!/bin/sh

#
# create 'view' scripts
#

cd `dirname $0` && . ../Configuration

if [ $# -eq 1 ]
then
    findObject=$1_create.object
else
    findObject=*_create.object
fi

#
# edit "create" views from sybase to postgres
#

#
# copy mgddbschema/view/*_create.object to postgres directory
#
cd ${PG_MGD_DBSCHEMADIR}/view
cp ../../mgddbschema/view/${findObject} .

#
# convert each mgd-format view script to a postgres script
#

for i in ${findObject}
do

ed $i <<END
g/csh -f -x/s//sh/g
g/ source/s// ./g
g/create view /s//create view mgd./g
g/^go/s///g
g/offset/s//cmOffset/g
g/convert(varchar(5), t.stage)/s//cast(t.stage as varchar(5))/g
g/convert(varchar(30), a.accID)/s//cast(a.accID as varchar(30))/g
g/convert(varchar(10), r._Class_key)/s//cast( r._Class_key as varchar(10))/g
g/convert(varchar(5), tag)/s//cast(tag as varchar(5))/g
g/convert(char(10), h.event_date, 101)/s//cast(h.event_date as char(10))/g
g/convert(varchar(10), r._Class_key)/s//cast(r._Class_key as varchar(10))/g
g/convert(varchar(10), r._Refs_key)/s//cast(r._Refs_key as varchar(10))/g
g/ltrim(str(l.size,10,2))/s//to_char(l.size, '9999.99')/g
g/'Allele'/s//character varying(10) 'Allele'/g
g/'Marker'/s//character varying(10) 'Marker'/g
g/'Probe'/s//character varying(10) 'Probe'/g
g/"/s//'/g
/cat
d
a
cat - <<EOSQL | \${PG_DBUTILS}/bin/doisql.csh \$0

.
/^use
d
d
d
.
/^checkpoint
;d
.
a
;

EOSQL
.
w
q
END

done

