#!/usr/local/bin/python

#
# translate the sybase stored procedure to postgres
#
# Usage: Translator().translateFile(spFunc)
# 	Or from command line:
#	python translatesp.py procName

import sys 
import os
import string

### BLOCK TYPES ###
# These are only used to differentiate blocks
STARTUP = "startup"
DECLARE = "declare"
CREATE = "create"
SELECT = "select"
INSERT = "insert"
UPDATE = "update"
DELETE = "delete"
CHECKPOINT = "checkpoint"
COMMENT = "comment"

class Translator(object):

	# Environment Variables
	# set relative paths to this directory if environment variables not set
	MGD_DBSCHEMADIR = os.getenv('MGD_DBSCHEMADIR') or '../../mgddbschema'
	PG_MGD_DBSCHEMADIR = os.getenv('PG_MGD_DBSCHEMADIR') or '..'

	# Main translator function
	# converts sybase file to a pg file
	# uses the above schema directories
	def translateFile(self,spFunc):
		contents = self.readInput(spFunc)
		translation = self.translate(fileLines)
		self.writeOutput(spFunc,translation)

	# takes in string of SQL procedure
	# return translated procedure
	def translate(self,originalSQL):
		global STARTUP,DECLARE,CREATE,INSERT,UPDATE,DELETE

		startUp = []
		endUp = []
		creation = []
		variables = []
		declarations = []
		statements = []

		originalLines = originalSQL.split('\n')
		spFunc = self.getSpFuncName(originalLines)

		# get the high level statement blocks
		topBlocks = self.getBlocks(originalSQL.split('\n'))

		for blockType,lines in topBlocks:

			#
			# start block : begins where "#!/bin/csh" used to be
			#
			if blockType == STARTUP:
				startUp.append(lines[0].replace('csh -f', 'sh'))
				for r in lines[1:]:
					if r.find('cd `dirname') >= 0:
						startUp.append(r.replace(' source', ' .'))
					elif r.find('cat ') >= 0:
						startUp.append('cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0\n')
						startUp.append('\nDROP FUNCTION %s();\n' % (spFunc))
					elif r.find('use') >= 0 or r.find('go') >= 0:
						continue
					else:
						startUp.append(r)

			#
			# create statement
			#
			elif blockType == CREATE:
				firstLine = lines[0]
				firstLine = firstLine.replace('create procedure', 'CREATE OR REPLACE FUNCTION')
				firstLine = firstLine.strip() + '(\n'
				creation.append(firstLine)
				for r in lines[1:]:
					r = r.replace('@', '')
					r = r.replace('"', '\'')
					r = r.replace('integer', 'int')
					if r.find('as\n') >= 0 or r.strip() == 'as':
						r = ')\nRETURNS VOID AS\n\\$\\$\n'
						creation.append(r)

					elif r.find('int') >= 0:
						variables.append('int')
						creation.append(r)

					elif r.find('varchar') >= 0:
						variables.append('varchar')
						creation.append(r)

			#
			# declare variables
			#
			elif blockType == DECLARE:
				for r in lines:
					r = r.replace('declare ', '')
					r = r.replace('@', '')
					r = r.replace('integer', 'int')
					r = r.strip() + ';\n'
					declarations.append(r)

			#
			# statments : select, insert, update, delete
			#
			elif blockType == SELECT:
				for r in lines:
					r = r.replace('user_name()', 'current_user')
					r = r.replace('@', '')
					r = r.strip() + ';\n'
					statements.append(r)

			elif blockType in [INSERT,UPDATE,DELETE]:
				for r in lines:
					r = r.replace('go', '')
					r = r.replace('@', '')
					statements.append(r)
				statements.append(';\n\n')

		#
		# end block : begins where "checkpoint" used to be
		#
		endUp.append('END;\n\\$\\$\nLANGUAGE plpgsql;\n\n')
		endUp.append('GRANT EXECUTE ON FUNCTION %s(' % (spFunc) \
			+ string.join(variables, ',') + ') TO public;\n\n')
		endUp.append('EOSQL')

				
		#
		# put all the pieces together
		#
		finalLines = []
		finalLines.append(''.join(map(str, startUp)) + '\n')
		finalLines.append(''.join(map(str, creation)) + '\n')
		finalLines.append('DECLARE\n')
		finalLines.append(''.join(map(str, declarations)) + '\n')
		finalLines.append('\nBEGIN\n\n')
		finalLines.append(''.join(map(str, statements)) + '\n')
		finalLines.append(''.join(map(str, endUp)) + '\n')

		return ''.join(finalLines)

	def getSpFuncName(self,lines):
		for line in lines:
			blockType = self.getBlockType(line)
			if blockType == CREATE:
				begin = 'create procedure'
				si = line.find(begin)
				si = line.find(' ',si+len(begin))
				name = line[si:].strip()
				return name
		return ''

	# parse a number of input lines for statement blocks
	# a block can be 1->many lines long
	# returns [type,lines] for each block
	def getBlocks(self,lines):
		blockType = None
		currentLines = []
		blocks = []
		for line in lines:
			# remove any empty lines
			if not line.strip():
				continue

			# check if line starts a block
			newType = self.getBlockType(line)
			if newType:
				# we have a new block
				# save the previous block
				if currentLines:
					blocks.append([blockType,currentLines])	
				# reset the block state
				currentLines = []
				blockType = newType

			# append line to current block
			currentLines.append(line)

		# save the previous block
		if currentLines:
			blocks.append([blockType,currentLines])	
			
		return blocks

	# returns block type for a line that starts the block
	# if the line does not start a block, it returns nothing
	def getBlockType(self,line):
		global STARTUP,CREATE,DECLARE,SELECT,INSERT,DELETE
		if line.find('/*') >= 0:
			return COMMENT
		elif line.find('#!/bin/csh') >= 0:
			return STARTUP
		elif line.find('create procedure') >= 0:
			return CREATE
		elif line.find('declare') >= 0:
			return DECLARE
		elif line.find('select') >= 0:
			return SELECT
		elif line.find('insert') >= 0:
			return INSERT
		elif line.find('update') >= 0:
			return UPDATE
		elif line.find('delete') >= 0:
			return DELETE
		elif line.find('checkpoint') >= 0:
			return CHECKPOINT
		return None

	# Read input from the sybase procedure file
	# returns a single string, lines separated by \n
	def readInput(self,spFunc):

		sybSP = self.MGD_DBSCHEMADIR + '/procedure/' + spFunc + '_create.object'

		sybIn = open(sybSP, 'r')
		contents = '\n'.join(sybIn.readlines())
		sybIn.close()
		return contents

	# Write the PG stored procedure file
	def writeOutput(self,spFunc,contents):

		pgSP = self.PG_MGD_DBSCHEMADIR + '/procedure/' + spFunc + '_create.object'

		if os.path.isfile(pgSP):
			os.system('rm -rf %s' % (pgSP))
		pgOut = open(pgSP, 'w+')

		pgOut.write(contents)
		pgOut.close()

		os.system('chmod 775 %s' % (pgSP))
	


if __name__ == "__main__":
	spFunc = sys.argv[1]
	Translator().translate(spFunc)
