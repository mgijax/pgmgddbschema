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

isCreate = 0
isGo = 0
isDeclare = 0
isBegin = 0
isVariable = 0

trackVars = [];

for r in sybIn.readlines():

	if r.find('#!/bin/csh') >= 0:
		r = r.replace('csh -f', 'sh')

	elif r.find('cd `dirname') >= 0:
		r = r.replace(' source', ' .')

	elif r.find('cat ') >= 0:
		r = 'cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0\n'
		r = r + '\nDROP FUNCTION %s();\n' % (spFunc)

	elif r.find('create procedure') >= 0:
		r = r.replace('create procedure', 'CREATE OR REPLACE FUNCTION')
		r = r.replace('\n', ' (\n')
		isCreate = 1

	elif r.find('as\n') >= 0 and isCreate:
		r = ')\nRETURNS VOID AS\n\\$\\$\n'
		isCreate = 0

	elif isCreate and r.find('integer') >= 0:
		trackVars.append('int')

	elif isCreate and r.find('varchar') >= 0:
		trackVars.append('varchar')

	elif r.find('declare') >= 0:
		r = r.replace('declare', 'DECLARE')
		r = r + '\nBEGIN\n'
		isDeclare = 1
		isBegin = 1

	elif (isDeclare \
	     or r.find('select') >= 0 \
	     or r.find('insert') >= 0 \
	     or r.find('update') >= 0 \
	     or r.find('delete') >= 0 \
	     ) \
	     and not isBegin:
		r = 'BEGIN\n\n' + r
		isBegin = 1

	elif r.find('go\n') >= 0 and not isGo:
		r = r.replace('go\n', ';\n')

	elif r.find('go\n') >= 0 and isGo:
		continue

	elif r.find('use') >= 0:
		continue

	elif r.find('checkpoint') >= 0:
		isGo = 1
		continue

	elif r.find('use ') >= 0 \
	     or r.find('quit') >= 0:
		continue

	elif r.find('EOSQL') >= 0:
		r = 'END;\n\\$\\$\nLANGUAGE plpgsql;\n\n'
		r = r + 'GRANT EXECUTE ON FUNCTION %s(' % (spFunc)
		r = r + string.join(trackVars, ',')
		r = r + ') TO public;\n\n'
		r = r + 'EOSQL'

	r = r.replace('@', '')
	r = r.replace('integer', 'int')
	r = r.replace('user_name()', 'current_user;')
	r = r.replace('"', '\'')

	pgOut.write(r)

sybIn.close()
pgOut.close()

os.system('chmod 775 %s' % (pgSP))

