#!/bin/sh

#
# Disables "user" triggers on a postgres table
#	(NOTE: there are system triggers for things like
#		referential integrity. Those remain unaffected)
#
#	Usage: 
#		enable_triggers.sh table_name
#
#	Assumes:
#		Database environment variables
#		(PG_DBSERVER, PG_DBNAME, PG_DBUSER, PG_DBPASSWORDFILE)
#		Schema is mgd
#

cd `dirname $0` && . ./Configuration

TABLE=${1}
SCHEMA=${2}

psql -h${PG_DBSERVER} -d${PG_DBNAME} -U${PG_DBUSER} --command "ALTER TABLE ${SCHEMA}.${TABLE} DISABLE TRIGGER USER;"

