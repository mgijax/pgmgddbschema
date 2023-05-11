#!/bin/csh -f

if ( ${?MGICONFIG} == 0 ) then
        setenv MGICONFIG /usr/local/mgi/live/mgiconfig
endif

source ${MGICONFIG}/master.config.csh

setenv TEMPFILE /tmp/`basename $0`.tmp
setenv RPTFILE `dirname $0`/`basename $0`.rpt
rm -f ${TEMPFILE} ${RPTFILE}

cd ${PG_MGD_DBSCHEMADIR}/key

# Use the create scripts in the key directory to generate a list of the
# tables/keys based on the current schema. We want to parse lines from
# the scripts that are similar to this:
#
# ALTER TABLE mgd.ACC_Accession ADD PRIMARY KEY (_Accession_key);
#
# The following command extracts the table/key from the line using this
# criteria
#
# 1) Make sure it has "ADD PRIMARY KEY".
# 2) Only include lines with "_key" that is used for integer keys.
# 3) Exclude lines with a comma that have multiple keys fields.
# 4) Remove everything up thru the "." (prior to the table name).
# 5) Replace everything from the space after the table name up thru the
#    "(" before the key name with a tab.
# 6) Remove the ending ");".
#
cat *_create.object | grep -i "ADD PRIMARY KEY" | grep "_key" | grep -v "," | sed "s/.*\.//" | sed "s/ .*(/\	/" | sed "s/);//"  > ${TEMPFILE}

cd ${PG_MGD_DBSCHEMADIR}/test

${PYTHON} ./checkMaxKeys.py
