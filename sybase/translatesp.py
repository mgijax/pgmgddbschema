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
IF = "if"
RETURN = "return"
COMMIT = "commit"
GO = "go"

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
		translation = self.translate(contents)
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
		topBlocks = self.getBlocks(originalLines)

		for blockType,lines in topBlocks:

			#
			# start block : begins where "#!/bin/csh" used to be
			#
			if blockType == STARTUP:
				translated = self.translateStartUpBlock(lines,spFunc)
				startUp.extend(translated)

			#
			# create statement
			#
			elif blockType == CREATE:
				translated, variables = self.translateCreateBlock(lines)
				creation.extend(translated)
			
			else:
				# once we are past the create procedure block
				# we can anticipate there could be control structures, like if/else and loops
				# translateNestedBlocks will go through any control structures recursively
				newStatements, newDeclarations = self.translateNestedBlock(blockType,lines)
				if newStatements:
					statements.extend(newStatements)
				if newDeclarations:
					declarations.extend(newDeclarations)

		#
		# end block : begins where "checkpoint" used to be
		#
		endUp.append('END;\n\\$\\$\nLANGUAGE plpgsql;\n')
		endUp.append('GRANT EXECUTE ON FUNCTION %s(' % (spFunc) \
			+ string.join(variables, ',') + ') TO public;\n')
		endUp.append('EOSQL')

				
		#
		# put all the pieces together
		#
		finalLines = []
		finalLines.append('\n'.join(map(str, startUp)) + '\n\n')
		finalLines.append('\n'.join(map(str, creation)) + '\n\n')
		if declarations:
			finalLines.append('DECLARE\n')
			finalLines.append('\n'.join(map(str, declarations)) + '\n\n')
		finalLines.append('\nBEGIN\n\n')
		finalLines.append('\n'.join(map(str, statements)) + '\n\n')
		finalLines.append('\n'.join(map(str, endUp)) + '\n')

		return ''.join(finalLines)

	# recursively translates any nested blocks inside a control structures
	# for example: if the blockType is IF,ELSEIF,ELSE, etc
	# returns any statements plus any declarations as two lists
	def translateNestedBlock(self,blockType,lines):
		statements = []
		declarations = []

		if blockType in IF:
			translated, declarations = self.translateIfBlock(lines)
			statements.extend(translated)
		#
		# declare variables
		#
		elif blockType == DECLARE:
			translated = self.translateDeclareBlock(lines)
			declarations.extend(translated)

		#
		# statments : select, insert, update, delete
		#
		elif blockType == SELECT:
			translated = self.translateSelectBlock(lines)
			statements.extend(translated)

		elif blockType == INSERT:
			translated = self.translateInsertBlock(lines)
			statements.extend(translated)

		elif blockType == UPDATE:
			translated = self.translateUpdateBlock(lines)
			statements.extend(translated)

		elif blockType == DELETE:
			translated = self.translateDeleteBlock(lines)
			statements.extend(translated)

		elif blockType == RETURN:
			translated = self.translateReturnBlock(lines)
			statements.extend(translated)

		# Add theses blocks untranslated
		elif blockType in [COMMENT]:
			statements.extend(lines)

		# else: anything not speficially handled above gets omitted

		return statements,declarations

	### Functions for Translating Different Block Types ###
	# 
	# They all take in lines representing the block
	# 	and return the translated lines
	#

	def translateStartUpBlock(self,lines,spFunc):
		translated = []
		translated.append(lines[0].replace('csh -f', 'sh'))
		for r in lines[1:]:
			if r.find('cd `dirname') >= 0:
				translated.append(r.replace(' source', ' .'))
			elif r.find('cat ') >= 0:
				translated.append('cat - <<EOSQL | ${PG_DBUTILS}/bin/doisql.csh $0')
				translated.append('\nDROP FUNCTION %s();' % (spFunc))
			elif r.find('use') >= 0 or r.find('go') >= 0:
				continue
			else:
				translated.append(r)
		return translated

	def translateCreateBlock(self,lines):
		translated = []
		variables = []
		firstLine = lines[0]
		firstLine = firstLine.replace('create procedure', 'CREATE OR REPLACE FUNCTION')
		firstLine = firstLine.strip() + ' ('
		translated.append(firstLine)
		hasOutput = 0

		for r in lines[1:]:
			r = r.replace('@', '')
			r = r.replace('"', '\'')
			r = r.replace('integer', 'int')

			# check if we have output parameter
			if r.find('out') > 0:
				r = r.replace(' out','')
				r = 'out ' + r
				hasOutput = 1

			if r.strip() == 'as':
				if hasOutput:
					r = ')\nAS\n\\$\\$'
				else:
					r = ')\nRETURNS VOID AS\n\\$\\$'
				translated.append(r)

			elif r.find('int') >= 0:
				variables.append('int')
				translated.append(r)

			elif r.find('varchar') >= 0:
				variables.append('varchar')
				translated.append(r)

		return translated,variables

	def translateDeclareBlock(self,lines):
		translated = []
		for r in lines:
			r = r.replace('declare ', '')
			r = r.replace('@', '')
			r = r.replace('integer', 'int')
			r = r.strip() + ';'
			translated.append(r)
		return translated

	def translateSelectBlock(self,lines):
		translated = []
		for r in lines:
			# convert variable assignment to PG style
			selectIntoPos = r.find('select @')
			equalPos = r.find('=')
			if selectIntoPos >= 0 and equalPos > selectIntoPos:
				r = r.replace('select @','select into ')
				if r.find(' = ') >= selectIntoPos:
					r = r.replace(' = ',' ',1)
				else:
					r = r.replace('=',' ',1)
				
			r = r.replace('user_name()', 'current_user')
			r = r.replace('@', '')
			translated.append(r)
		translated.append(';\n')
		return translated

	def translateInsertBlock(self,lines):
		translated = []
		for r in lines:
			if r.strip() == 'go':
				continue
			r = r.replace('@', '')
			translated.append(r)
		translated.append(';\n')
		return translated

	def translateUpdateBlock(self,lines):
		translated = []
		for r in lines:
			if r.strip() == 'go':
				continue
			r = r.replace('@', '')
			translated.append(r)
		translated.append(';\n')
		return translated

	def translateDeleteBlock(self,lines):
		translated = []
		for r in lines:
			if r.strip() == 'go':
				continue
			r = r.replace('@', '')
			translated.append(r)
		translated.append(';\n')
		return translated

	def translateReturnBlock(self,lines):
		translated = []
		for r in lines:
			translated.append(r + ';')
		return translated

	def translateIfBlock(self,lines):
		statements = []
		declarations = []
		innerBlock = []
		
		subIfCount = 0
		for i in range(len(lines)):
			r = lines[i]
			r = r.replace('@','')
			if r.strip() == '':
				continue

			if r.strip() == 'begin':
				if subIfCount == 0:
					statements.append('then')	
				else:
					innerBlock.append(r)
				subIfCount += 1	
			
			elif r.strip() == 'end':
				subIfCount -= 1
				if subIfCount == 0:
					# parse the inner block and append anything inside to the statements list
					innerBlocks = self.getBlocks(innerBlock)
					for blockType,innerLines in innerBlocks:
						newStatements, newDeclarations = self.translateNestedBlock(blockType,innerLines)
						# shift nested statements over nested dist
						newStatements = ['\t' + l for l in newStatements]
						statements.extend(newStatements)
						declarations.extend(newDeclarations)
					# reset the innerBlock lines
					innerBlock = []
				else:
					innerBlock.append(r)
				
			elif subIfCount > 0:
				innerBlock.append(r)
			else:
				statements.append(r)
		
		statements.append('end if;\n')
		return statements, declarations


	# pulls the procedure name out of the create statement
	# NOTE: this isn't 100% necessary, 
	#	but it makes the database tests a bit easier to write
	#	if the code and infer the procedure name
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
		blocks = []
		startIndex = 0
		while startIndex < len(lines):
			newType, endIndex = self.getNextBlock(startIndex,lines)
			if newType:
				blocks.append([newType, lines[startIndex:endIndex]])

			startIndex = endIndex 

		# remove blank lines
		for i in range(len(blocks)):
			blockType, lines = blocks[i]
			blocks[i] = [blockType, filter(None, [l.strip() for l in lines])]

		return blocks

	# Starting at index, iterate through the lines
	# returning the next block type and the index of the last line in the block
	def getNextBlock(self,index,lines):
		firstLine = lines[index]
		# find the type
		blockType = self.getBlockType(firstLine)

		# handle blocks with special end characters first,
		# else simply search for the next valid block after this one
		if blockType == COMMENT:
			# search for comment end
			for i in range(index,len(lines)):
				line = lines[i]
				if line.find("*/") >= 0:
					return blockType, i+1
		elif blockType == IF:
			# search for if statement end
			# ignore any sub if statements (they will be parsed later)
			# include all the else statements that are part of this entire if block
			subIfCount = 0
			for i in range(index+1,len(lines)):
				line = lines[i].strip()
				if line.find('begin') == 0:
					subIfCount += 1
				elif line.find('end') == 0:
					subIfCount -= 1
				if subIfCount == 0:
					# here we essentially look for the next type of block that isn't 
					# part of a sub-if, or else if/else block
					nextType = self.getBlockType(line)
					if nextType:
						return blockType, i
		else:
			# search for next type
			for i in range(index+1,len(lines)):
				line = lines[i]
				nextType = self.getBlockType(line)
				if nextType:
					return blockType, i
		return blockType, len(lines)
		

	# returns block type for a line that starts the block
	# if the line does not start a block, it returns nothing
	def getBlockType(self,line):
		global STARTUP,CREATE,DECLARE,SELECT,INSERT,DELETE
		line = line.strip()
		if line.find('/*') == 0:
			return COMMENT
		elif line.find('if') == 0:
			return IF
		elif line.find('return') == 0:
			return RETURN
		elif line.find('commit') >= 0:
			return COMMIT
		elif line.find('#!/bin/csh') == 0:
			return STARTUP
		elif line.find('create procedure') == 0:
			return CREATE
		elif line.find('declare') == 0:
			return DECLARE
		elif line.find('select') == 0:
			# make sure this isn't a sub select
			si = line.find('select')
			if si > 0 and line[si-1] == '(':
				return None
			return SELECT
		elif line.find('insert') == 0:
			return INSERT
		elif line.find('update') == 0:
			return UPDATE
		elif line.find('delete') == 0:
			return DELETE
		elif line.find('checkpoint') == 0:
			return CHECKPOINT
		elif line.find("go") == 0:
			return GO
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
	Translator().translateFile(spFunc)
