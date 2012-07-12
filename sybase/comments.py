#!/usr/local/bin/python

#
# create .txt file of:
#
#	MGI_Table.table_name
#	MGI_Tables.description
#

import sys 
import os
import pg_db

db = pg_db
db.setTrace()

fp = open('comments.txt', 'w')

results = db.sql('select table_name, description from MGI_Tables', 'auto')

for r in results:

    tableName = r['table_name']
    description = r['description']

    if description != None:
    	description = description.replace("'", "''")

    fp.write("COMMENT ON TABLE mgd." + tableName + " IS '" + str(description) + "';\n")

results = db.sql('select table_name, column_name, description from MGI_Columns', 'auto')

for r in results:

    tableName = r['table_name']
    columnName = r['column_name']
    description = r['description']

    if description != None:
    	description = description.replace("'", "''")
    	description = description.replace("offset", "cmOffset")

    columnName = columnName.replace("offset", "cmOffset")

    fp.write("COMMENT ON COLUMN " + tableName + "." + columnName + " IS '" + str(description) + "';\n")

fp.close()

