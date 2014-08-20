import unittest
import translatesp

Translator = translatesp.Translator

# Test the getBlocks() function
class GetBlocksTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()
	
	### TESTS ###
	def testGetBlocksEmpty(self):
		blocks = self.translator.getBlocks([])
		self.assertEquals(0,len(blocks))
	
	def testGetBlocksCreateHasCorrectType(self):
		lines = ["create procedure TEST ",
			"\t@var1 int","as"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.CREATE,blocks[0][0])

	def testGetBlocksCreateHasCorrectLines(self):
		lines = ["create procedure test",
			"\t@var1 int","as"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(3,len(blocks[0][1]))
		self.assertEquals("create procedure test",blocks[0][1][0])

	def testGetBlocksSingleUpdateLine(self):
		lines = ["update table1 set col1 = thing where col1 = val1"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(1,len(blocks[0][1]))

	def testGetBlocksSingleLineUpdateHasCorrectType(self):
		lines = ["update table1 set col1 = thing where col1 = val1"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.UPDATE,blocks[0][0])

	def testGetBlocksSingleLineDeleteHasCorrectType(self):
		lines = ["delete blah blah"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.DELETE,blocks[0][0])

	def testGetBlocksSingleLineSelectHasCorrectType(self):
		lines = ["select blah blah"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.SELECT,blocks[0][0])

	def testGetBlocksSingleLineInsertHasCorrectType(self):
		lines = ["insert blah blah"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.INSERT,blocks[0][0])

	def testGeBlocksCommentBlockHasCorrectType(self):
		lines = ["/* comment */"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.COMMENT,blocks[0][0])

	def testGeBlocksCommentBlockSingleLine(self):
		lines = ["/* comment */"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(1,len(blocks[0][1]))
		self.assertEquals("/* comment */",blocks[0][1][0])

	def testGeBlocksCommentBlockMultiLine(self):
		lines = ["/* comment line 1","* line 2 *","* final line */"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(3,len(blocks[0][1]))
		self.assertEquals(lines,blocks[0][1])

	def testGetBlocksManyTypes(self):
		lines = ["create procedure x","...","...","as",
			"declare some var",
			"/* comment 1 *","...","..."," end comment */",
			"select something","...",
			"delete something from something else","..."]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(5,len(blocks))

	def testGetBlocksMultipleDeclares(self):
		lines = ["declare x","declare y","declare u"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(3,len(blocks))

	def testGetBlocksSingleIfBlock(self):
		lines = ["if exists something","begin","\treturn","end"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.IF,blocks[0][0])
		self.assertEquals(4,len(blocks[0][1]))

	def testGetBlocksIfBlockWithSubIfs(self):
		lines = ["if exists something","begin",
			"...","if sub thing","begin","...","end",
			"else if sub thing2","begin","\treturn","end"
			,"\treturn","end"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(len(lines),len(blocks[0][1]))

	def testGetBlocksElseIfBlock(self):
		lines = ["if exists something","begin","\treturn","end",
			"else if somthing","begin","...","end"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(1,len(blocks))
		self.assertEquals(translatesp.IF,blocks[0][0])

	def testGetBlocksElsefBlock(self):
		lines = ["if exists something","begin","\treturn","end",
			"else somthing","begin","...","end"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(1,len(blocks))
		self.assertEquals(translatesp.IF,blocks[0][0])

# Test the translateIfBlock() function
# NOTE: this is a component test, rather than a unit test
#	This may make it slightly fragile and break if underlying components change
#	Like how nested blocks and statements are formatted
class TranslateIfBlockTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()
	
	### TESTS ###
	def testTranslateIfBlockSingleEmptyIf(self):
		lines = ["if exists something","begin","end"]
		statements, declarations = self.translator.translateIfBlock(lines)
		self.assertEquals("if exists something\nthen\nend if;\n","\n".join(statements))

	def testTranslateIfBlockSingleIfWithSelect(self):
		lines = ["if exists something","begin","select test","end"]
		statements, declarations = self.translator.translateIfBlock(lines)
		self.assertEquals("if exists something\nthen\nselect test\n;\n\nend if;\n","\n".join(statements))

	def testTranslateIfWithElses(self):
		lines = ["if exists something","begin","end",
			"else if exists something2","begin","end",
			"else","begin","end"]
		statements, declarations = self.translator.translateIfBlock(lines)
		self.assertEquals("if exists something\nthen\nelse if exists something2\nthen\nelse\nthen\nend if;\n","\n".join(statements))


class GetSpFuncNameTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()

	### TESTS ###
	def testGetSpFuncNameNoLines(self):
		self.assertEquals("",self.translator.getSpFuncName([]))

	def testGetSpFuncNameBasic(self):
		self.assertEquals("testFunc",self.translator.getSpFuncName(["create procedure testFunc "]))

	def testGetSpFuncNameManyLines(self):
		self.assertEquals("testFunc",self.translator.getSpFuncName(["blah blah blah","create procedure testFunc ","blah blah blah"]))


def suite():
	suitesToRun = [
		GetBlocksTest,
		TranslateIfBlockTest,
		GetSpFuncNameTest
	]
	suites = [unittest.TestLoader().loadTestsFromTestCase(ts) for ts in suitesToRun]
	allTests = unittest.TestSuite(suites)
	return allTests

if __name__ == "__main__":
	unittest.main()
