import unittest
import translatesp

Translator = translatesp.Translator

class TranslateConvertStatementTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()
	
	### TESTS ###
	def testTranslateConvertNotFount(self):
		line = "select var from table"
		translated = self.translator.translateConvert(line)
		self.assertEquals(line, translated)

	def testTranslateConvertInteger(self):
		line = "convert(integer, var1)"
		translated = self.translator.translateConvert(line)
		self.assertEquals("var1::integer", translated)

	def testTranslateConvertChar(self):
		line = "convert(char(10), var1)"
		translated = self.translator.translateConvert(line)
		self.assertEquals("var1::char(10)", translated)

	def testTranslateConvertVarchar(self):
		line = "convert(varchar(100), var1)"
		translated = self.translator.translateConvert(line)
		self.assertEquals("var1::varchar(100)", translated)

	def testTranslateConvertWithSurroundingWords(self):
		line = "if t > convert(integer, var1) and isTest"
		translated = self.translator.translateConvert(line)
		self.assertEquals("if t > var1::integer and isTest", translated)

	def testTranslateConvertMultiples(self):
		line = "convert(integer, var1) + convert(varchar(20), var2)"
		translated = self.translator.translateConvert(line)
		self.assertEquals("var1::integer + var2::varchar(20)", translated)

class TranslateCreateBlockTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()
	
	### TESTS ###
	def testTranslateCreateBlockBasic(self):
		lines = ["create procedure x","as"]
		statements,variables = self.translator.translateCreateBlock(lines)
		self.assertEquals(["CREATE OR REPLACE FUNCTION x (",')\nRETURNS VOID AS\n\\$\\$'],statements)

	def testTranslateCreateBlockWithParams(self):
		lines = ["create procedure x","@var1 integer,","@var2 varchar(10)","as"]
		statements,variables = self.translator.translateCreateBlock(lines)
		self.assertEquals(["CREATE OR REPLACE FUNCTION x (","var1 int,","var2 varchar(10)",')\nRETURNS VOID AS\n\\$\\$'],statements)

	def testTranslateCreateBlockWithParamsCheckVariables(self):
		lines = ["create procedure x","@var1 integer,","@var2 varchar(10)","as"]
		statements,variables = self.translator.translateCreateBlock(lines)
		self.assertEquals(["int","varchar"],variables)

	def testTranslateCreateBlockWithParamsCheckOutputVariables(self):
		lines = ["create procedure x","@var1 integer,","@var2 varchar(10) out,","@var3 integer","as"]
		statements,variables = self.translator.translateCreateBlock(lines)
		self.assertEquals(["int","int"],variables)

	def testTranslateCreateBlockOutParam(self):
		lines = ["create procedure x","@prefixPart varchar(30) out","as"]
		statements,variables = self.translator.translateCreateBlock(lines)
		self.assertEquals(["CREATE OR REPLACE FUNCTION x (","out prefixPart varchar(30)",')\nAS\n\\$\\$'],statements)

	def testTranslateCreateBlockOutputParam(self):
		lines = ["create procedure x","@prefixPart varchar(30) output","as"]
		statements,variables = self.translator.translateCreateBlock(lines)
		self.assertEquals(["CREATE OR REPLACE FUNCTION x (","out prefixPart varchar(30)",')\nAS\n\\$\\$'],statements)
		

class TranslateSelectBlockTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()
	
	### TESTS ###
	def testTranslateSelectBasic(self):
		lines = ["select * from table"]
		statements = self.translator.translateSelectBlock(lines)
		self.assertEquals(["select * from table",";\n"],statements)

	def testTranslateSelectMultiline(self):
		lines = ["select * from table","where x = 1","and y = 2"]
		statements = self.translator.translateSelectBlock(lines)
		self.assertEquals(["select * from table","where x = 1","and y = 2",";\n"],statements)

	def testTranslateSelectInto(self):
		lines = ["select @var1 = col from table"]
		statements = self.translator.translateSelectBlock(lines)
		self.assertEquals(["select into var1 col from table",";\n"],statements)

	def testTranslateSelectIntoVariation2(self):
		lines = ["select @var1=col from table"]
		statements = self.translator.translateSelectBlock(lines)
		self.assertEquals(["select into var1 col from table",";\n"],statements)

	def testTranslateSelectIntoMultiline(self):
		lines = ["select @var1 = col from table","where col='test'"]
		statements = self.translator.translateSelectBlock(lines)
		self.assertEquals(["select into var1 col from table","where col='test'",";\n"],statements)

class TranslateDeleteBlockTest(unittest.TestCase):
	def setUp(self):
		self.translator = Translator()

	### TESTS ###
	def testTranslateDeleteBasic(self):
		lines = ["delete x from y"]	
		statements = self.translator.translateDeleteBlock(lines)
		self.assertEquals(["delete x from y",";\n"],statements)

	def testTranslateDeleteMultiline(self):
		lines = ["delete x","from y","where y = 2"]
		statements = self.translator.translateDeleteBlock(lines)
		self.assertEquals(["delete x","from y","where y = 2",";\n"],statements)

	def testTranslateDeleteUsingTables(self):
		lines = ["delete x","from y","from x,y,z","where blah"]
		statements = self.translator.translateDeleteBlock(lines)
		self.assertEquals(["delete x","from y","using x,y,z","where blah",";\n"],statements)

	def testTranslateDeleteUsingTablesVariation2(self):
		lines = ["delete from x","from x,y,z","where blah"]
		statements = self.translator.translateDeleteBlock(lines)
		self.assertEquals(["delete from x","using x,y,z","where blah",";\n"],statements)

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
		self.assertEquals("if exists something\nthen\n\tselect test\n\t;\n\nend if;\n","\n".join(statements))

	def testTranslateIfBlockNestedIfs(self):
		lines = ["if nest1","begin","if nest2","begin","if nest3","begin","end","end","end"]
		statements, declarations = self.translator.translateIfBlock(lines)
		self.assertEquals(["if nest1","then",
			"\tif nest2","\tthen",
				"\t\tif nest3","\t\tthen","\t\tend if;\n",
			"\tend if;\n",
			"end if;\n"],statements)

	def testTranslateIfWithElses(self):
		lines = ["if exists something","begin","end",
			"else if exists something2","begin","end",
			"else","begin","end"]
		statements, declarations = self.translator.translateIfBlock(lines)
		self.assertEquals("if exists something\nthen\nelse if exists something2\nthen\nelse\nthen\nend if;\n","\n".join(statements))

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

	def testGetBlocksInsertIntoWithSelect(self):
		lines = ["insert into table","select from table"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(translatesp.INSERT,blocks[0][0])
		self.assertEquals(1,len(blocks))
		self.assertEquals(2,len(blocks[0][1]))

	def testGetBlocksInsertIntoWithoutSelect(self):
		lines = ["insert into","some values","select * from table"]
		blocks = self.translator.getBlocks(lines)
		self.assertEquals(2,len(blocks))
		self.assertEquals(translatesp.INSERT,blocks[0][0])
		self.assertEquals(translatesp.SELECT,blocks[1][0])

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
		TranslateConvertStatementTest,
		TranslateCreateBlockTest,
		TranslateSelectBlockTest,
		TranslateDeleteBlockTest,
		TranslateIfBlockTest,
		GetBlocksTest,
		GetSpFuncNameTest
	]
	suites = [unittest.TestLoader().loadTestsFromTestCase(ts) for ts in suitesToRun]
	allTests = unittest.TestSuite(suites)
	return allTests

if __name__ == "__main__":
	unittest.main()
