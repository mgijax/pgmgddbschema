#!/bin/sh

cd `dirname $0` && . ../Configuration

if [ $# -eq 1 ]
then
    findObject=$1_drop.object
else
    findObject=*_drop.object
fi

#
# copy mgddbschema/index/*_drop.object to postgres directory
#
cd ../index
cp ../../mgddbschema-trunk/index/${findObject} .

for i in ${findObject}
do

t=`basename $i _drop.object`

ed $i <<END
/idx_primary
d
d
d
.
g/csh -f -x/s//sh/g
g/ source/s// ./g
g/drop index /s//drop index mgd./g
g/${t}.idx/s//${t}_idx/g
g/offset/s//cmOffset/g
g/^go/s//\\;/g
/cat
d
.
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
EOSQL
.
w
q
END

done

