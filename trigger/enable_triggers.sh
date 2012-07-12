#!/bin/sh

#
# Usage:
# enable_triggers.sh <table name> [<trigger name>]
#
# Purpose:
# enable all triggers on the given table, or a
# single trigger if one is specified by name
#

cd `dirname $0` && . ./Configuration

cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh ${MGD_DBSERVER} ${MGD_DBNAME} $0

ALTER TABLE $1 ENABLE TRIGGER $2 ALL
go

EOSQL
