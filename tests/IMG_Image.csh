#!/bin/csh -f

#
# Purpose:
#
# To test that the referential-integrity for the table is correct between the parents and children:
#
#	. FOREIGN KEY
#	. REFERENCES/ON DELETE CASCADE
#
# Refer to the 'key/table_create.object' ALTER TABLE list (should match)
#
# children without cascading deletes:
#	. DELETE statements should fail
#
# children with cascading deletes:
#	. DELETE statements should succeed
#
# table : IMG_Image
#
# children w/ cascading deletes:
# ACC_AccessionReference
# IMG_ImagePane
# IMG_Image_Cache
#
# children other:
# IMG_ImagePane_Assoc
#
# see 'foreach' loop below
#

#setenv MGICONFIG /usr/local/mgi/live/mgiconfig
#setenv MGICONFIG /usr/local/mgi/test/mgiconfig
#source ${MGICONFIG}/master.config.csh

cd `dirname $0`

setenv TESTLOG $0.log
rm -rf $TESTLOG
touch $TESTLOG
 
date | tee -a $TESTLOG
 
#cat - <<EOSQL | doisql.csh $MGD_DBSERVER $MGD_DBNAME $0 | tee -a $TESTLOG
#use $MGD_DBNAME
#go
#EOSQL

#
# testing deletes the should return errors due to referential integrity restrictions
#

foreach i (GXD_Assay GXD_InSituResultImage IMG_ImagePane_Assoc)

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG

SELECT v.*
INTO TEMPORARY img
FROM IMG_ImagePaneGXD_View v, ${i} a
WHERE v._ImagePane_key = a._ImagePane_key
LIMIT 1
;

SELECT * FROM img WHERE _Image_key IN (SELECT _Image_key FROM img)
;

DELETE FROM IMG_Image WHERE _Image_key IN (SELECT _Image_key FROM img)
;

EOSQL

end

#
# test that a record without any referential integrity checks is properly deleted
#

psql -h ${PG_DBSERVER} -U ${PG_DBUSER} -d ${PG_DBNAME} -e <<EOSQL |& tee -a $TESTLOG

SELECT v.*
INTO TEMPORARY img
FROM IMG_ImagePaneGXD_View v, ${i} a
WHERE v._ImagePane_key = a._ImagePane_key
AND NOT EXISTS (SELECT 1 FROM GXD_Assay a WHERE a._ImagePane_key = v._ImagePane_key)
LIMIT 1
;

SELECT * FROM img WHERE _Image_key IN (SELECT _Image_key FROM img)
;

DELETE FROM IMG_Image WHERE _Image_key IN (SELECT _Image_key FROM img)
;

EOSQL

date | tee -a $TESTLOG

