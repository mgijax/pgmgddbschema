#!/usr/local/bin/python

#
# translate the sybase stored procedure to postgres
#

import sys 
import os
import string

spFunc = sys.argv[1]
sybSP = os.getenv('MGD_DBSCHEMADIR') + '/procedure/' + spFunc + '_create.object'
pgSP = os.getenv('PG_MGD_DBSCHEMADIR') + '/procedure/' + spFunc + '_create.object'
os.system('rm -rf %s' % (pgSP))

sybIn = open(sybSP, 'r')
pgOut = open(pgSP, 'w+')

isStartUp = 0
isEndUp = 0
isCreate = 0
isStatement = 0

startUp = []
endUp = []
creation = []
variables = []
declarations = []
statements = []
needSemi = 0

for r in sybIn.readlines():

	if r.find('#!/bin/csh') >= 0:
		startUp.append(r.replace('csh -f', 'sh'))
		isStartUp = 1

	elif isStartUp:
		if r.find('cd `dirname') >= 0:
			startUp.append(r.replace(' source', ' .'))
		elif r.find('cat ') >= 0:
			startUp.append('cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0\n')
			startUp.append('\nDROP FUNCTION %s();\n' % (spFunc))
			isStartUp = 0
		elif r.find('use') >= 0 or r.find('go') >= 0:
			continue
		else:
			startUp.append(r)

	elif r.find('create procedure') >= 0:
		r = r.replace('create procedure', 'CREATE OR REPLACE FUNCTION')
		r = r.replace('\n', ' (\n')
		creation.append(r)
		isCreate = 1
		isStartUp = 0

	elif isCreate:
		r = r.replace('@', '')
		r = r.replace('"', '\'')
		r = r.replace('integer', 'int')
		if r.find('as\n') >= 0:
			r = ')\nRETURNS VOID AS\n\\$\\$\n'
			creation.append(r)
			isCreate = 0

		elif r.find('int') >= 0:
			variables.append('int')
			creation.append(r)

		elif r.find('varchar') >= 0:
			variables.append('varchar')
			creation.append(r)

	elif r.find('declare') >= 0:
		r = r.replace('declare ', '')
		r = r.replace('@', '')
		r = r.replace('integer', 'int')
		r = r.replace('\n', ';\n')
		declarations.append(r)

	elif r.find('select') >= 0 \
	     or r.find('insert') >= 0 \
	     or r.find('update') >= 0 \
	     or r.find('delete') >= 0 :

		r = r.replace('user_name()', 'current_user')
		r = r.replace('@', '')
		statements.append(r)
		isStatement = 1
		needSemi = 1

	elif isStatement and r.find('checkpoint') < 0:
		r = r.replace('user_name()', 'current_user')
		r = r.replace('go', '')
		r = r.replace('@', '')

		if len(r) == 1 and needSemi:
			r = ';\n\n'
			needSemi = 0

		statements.append(r)
		isStatement = 1

	elif r.find('checkpoint') >= 0:
		isStatement = 0
		isEndUp = 1
		continue

	elif isEndUp:
		if r.find('go') >= 0 or r.find('quit') >= 0:
			continue

		elif r.find('EOSQL') >= 0:
			endUp.append('END;\n\\$\\$\nLANGUAGE plpgsql;\n\n')
			endUp.append('GRANT EXECUTE ON FUNCTION %s(' % (spFunc) \
				+ string.join(variables, ',') + ') TO public;\n\n')
			endUp.append('EOSQL')

#	pgOut.write(r)
sybIn.close()

#
# write to pgOut
#
pgOut.write(''.join(map(str, startUp)) + '\n')
pgOut.write(''.join(map(str, creation)) + '\n')
pgOut.write('DECLARE\n')
pgOut.write(''.join(map(str, declarations)) + '\n')
pgOut.write('\nBEGIN\n\n')
pgOut.write(''.join(map(str, statements)) + '\n')
pgOut.write(''.join(map(str, endUp)) + '\n')
pgOut.close()

os.system('chmod 775 %s' % (pgSP))

