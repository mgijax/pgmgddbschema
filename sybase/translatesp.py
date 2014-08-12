#!/usr/local/bin/python

import sys 
import os

#
# Main
#

spFunc = sys.argv[1]
sybSP = os.getenv('MGD_DBSCHEMADIR') + '/procedure/' + spFunc + '_create.object'
pgSP = os.getenv('PG_MGD_DBSCHEMADIR') + '/procedure/' + spFunc + '_create.object'
os.system('rm -rf %s' % (pgSP))

sybIn = open(sybSP, 'r')
pgOut = open(pgSP, 'w+')

isCreate = 0
isCheckpoint = 0

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

	elif isCreate:
		print 'in create...'

	elif r.find('declare') >= 0:
		r = r.replace('declare', 'DECLARE')
		r = r + '\nBEGIN\n'

	elif r.find('go\n') >= 0 and not isCheckpoint:
		r = r.replace('go\n', ';\n')

	elif r.find('go\n') >= 0 and isCheckpoint:
		continue

	elif r.find('checkpoint') >= 0:
		isCheckpoint = 1
		continue

	elif r.find('use ') >= 0 \
		or r.find('quit') >= 0:
		continue

	elif r.find('EOSQL') >= 0:
		r = 'END;\n\\$\\$\nLANGUAGE plpgsql;\n\n'
		r = r + 'GRANT EXECUTE ON FUNCTION %s(int, int) TO public;\n\n' % (spFunc)
		r = r + 'EOSQL'

	r = r.replace('@', '')
	r = r.replace('integer', 'int;')
	r = r.replace('user_name()', 'current_user;')

	pgOut.write(r)

sybIn.close()
pgOut.close()

os.system('chmod 775 %s' % (pgSP))


