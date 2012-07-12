#!/bin/sh

#
# NOTE:
#
# had to manually edit the *create.object scripts to include 
# "ON DELETE CASCADE" for instances where the child records
# can be deleted if the parent is record is deleted.
#
# a copy of *create.object has been stored in *create.object.save
#
# if you run this script, then you will *LOOSE* the manual edits
# of "ON DELETE CASCADE" that are in the *.save scripts
#

cd `dirname $0` && . ../Configuration

if [ $# -eq 1 ]
then
    findObject1=$1_create.object
    findObject2=$1_drop.object
else
    findObject1=*_create.object
    findObject2=*_drop.object
fi

#
# edit "sp_primarykey" and "sp_foreignkey" from sybase to postgres
#

#
# copy mgddbschema/key/*_create.object to postgres directory
# copy mgddbschema/key/*_drop.object to postgres directory
#
cd ../key
cp ../../mgddbschema/key/${findObject1} .
cp ../../mgddbschema/key/${findObject2} .

#
# convert each mgd-format key script to a postgres script
#
# sp_primarykey MRK_Marker, _Marker_key
# to
# ALTER TABLE MRK_Marker ADD PRIMARY KEY (_Marker_key);
#
# sp_foreignkey ALL_Allele, MRK_Marker, _Marker_key
# to
# ALTER TABLE ALL_Allele 
#	ADD CONSTRAINT ALL_Allele_Marker_key_fkey 
#	FOREIGN KEY (_Marker_key) REFERENCES MRK_Marker;
#
# add: );
# add: ) REFERENCE ${t};
#
# sp_dropkey foreign, ALL_Allele, MRK_Marker
# to
# ALTER TABLE ALL_Allele DROP CONSTRAINT xxxxx
#

for i in ${findObject1}
do

# master table name
t=`basename $i _create.object`

# primary key table name + key
pkey=`grep "sp_primarykey" ${i} | sed "s/sp_primarykey //g" | cut -f1,2 -d"," | sed "s/, /+/g"`

# foreign key table name + key
fkey=`grep "sp_foreignkey" ${i} | sed "s/sp_foreignkey //g" | cut -f1,3 -d"," | sed "s/, /+/g"`

ed $i <<END
g/csh -f -x/s//sh/g
g/ source/s// ./g
g/sp_primarykey ${t}, /s//ALTER TABLE mgd.${t} ADD PRIMARY KEY (/
g/PRIMARY KEY/s/$/);/
g/sp_foreignkey/s//ALTER TABLE mgd./
g/, ${t}, /s// ADD FOREIGN KEY (/
g/FOREIGN KEY/s/$/) REFERENCES mgd.${t};/
g/ALTER TABLE mgd. /s//ALTER TABLE mgd./
g/_Marker_key, ./s//_Marker_key, source/
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
g/^go/s///g
/^checkpoint
;d
a
EOSQL
.
w
q
END

#
# edit the drop script for the master table
#

dropScript=${t}_drop.object
ed ${dropScript} <<END
g/csh -f -x/s//sh/g
g/ source/s// ./g
g/sp_dropkey foreign, /d
g/sp_dropkey primary, /s//ALTER TABLE /
g/ALTER TABLE ${t}/s//ALTER TABLE mgd.${t} DROP CONSTRAINT ${t}_pkey CASCADE;/
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
g/^go/d
g/^$/d
/^checkpoint
;d
a

EOSQL
.
w
q
END

#
# for each foreign key
#
# fkey = ALL_Marker_Assoc+_Marker_key
#
# ALTER TABLE ALL_Marker_Assoc DROP CONSTRAIN
# convert to
# ALTER TABLE ALL_Marker_Assoc DROP CONSTRAIN ALL_Marker_Assoc__Marker_key_fkey CASCADE
#

# for each foreign key

for f in ${fkey}
do

#t2 = table name
t2=`echo ${f} | cut -f1 -d"+"`

#f2 = foreign key
f2=`echo ${f} | sed "s/+/_/g`

ed ${dropScript} <<END
/cat
a

ALTER TABLE mgd.${t2} DROP CONSTRAINT ${f2}_fkey CASCADE;
.
w
q
END
done

done

