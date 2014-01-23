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
cd ${PG_MGD_DBSCHEMADIR}/index
cp ../../mgddbschema/index/${findObject} .

for i in ${findObject}
do

t=`basename $i _drop.object`

ed $i <<END
g/csh -f/s//sh/g
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

ed $i <<END
/idx_primary
d
d
d
.
w
q
END

done

