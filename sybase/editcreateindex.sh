#!/bin/sh

#
# for indexes that contain 'idx_primary'
#

cd `dirname $0` && . ../Configuration

if [ $# -eq 1 ]
then
    findObject=$1_create.object
else
    findObject=*_create.object
fi

#
# copy mgddbschema/index/*_create.object to postgres directory
#
cd ../index
cp ../../mgddbschema/index/${findObject} .

for i in ${findObject}
do

t=`basename $i _create.object`

ed $i <<END
g/csh -f -x/s//sh/g
g/ source/s// ./g
g/ nonclustered /s// /g
g/ clustered /s// /g
g/idx/s//${t}_idx/g
g/ on seg2/s//;/g
g/ on seg3/s//;/g
g/ on seg4/s//;/g
g/ on seg5/s//;/g
g/ on seg6/s//;/g
g/ on seg7/s//;/g
g/ on seg8/s//;/g
g/ on \${DBCLUSTIDXSEG}/s//;/g
g/on \${DBCLUSTIDXSEG}/s//;/g
g/ on \$DBCLUSTIDXSEG/s//;/g
g/ on \${DBNONCLUSTIDXSEG}/s//;/g
g/ on \$DBNONCLUSTIDXSEG/s//;/g
g/offset/s//cmOffset/g
g/ on /s// on mgd./g
g/^go/s///g
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

