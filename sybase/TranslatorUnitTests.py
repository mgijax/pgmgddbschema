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


# Test the translateCreateProcedure Section
class CreateProcedureTest(unittest.TestCase):
	### TESTS ###

	def testCreateProcedureEmpty(self):
		self.assertEquals("",translatesp.translateCreateProcedure(""))

	def testCreateProcedureBasic(self):
		original = """create procedure Test
  @var1 int,
  @var2 int
as"""
		expected = """CREATE OR REPLACE FUNCTION Test (
  var1 int,
  var2 int
 
)
RETURNS VOID AS
\$\$"""
		self.assertEquals(expected,translatesp.translateCreateProcedure(original))

	def testCreateProcedureWithVarchar(self):
		original = """create procedure Test
  @var1 varchar
as"""
		expected = """CREATE OR REPLACE FUNCTION Test (
  var1 varchar
 
)
RETURNS VOID AS
\$\$"""
		self.assertEquals(expected,translatesp.translateCreateProcedure(original))

	def testCreateProcedureTrailingWhiteSpace(self):
		original = """   create procedure Test
  @var1 int
as    """
		expected = """CREATE OR REPLACE FUNCTION Test (
  var1 int
 
)
RETURNS VOID AS
\$\$"""
		self.assertEquals(expected,translatesp.translateCreateProcedure(original))

def suite():
	suitesToRun = [
		GetBlocksTest,
		GetSpFuncNameTest
	]
	suites = [unittest.TestLoader().loadTestsFromTestCase(ts) for ts in suitesToRun]
	allTests = unittest.TestSuite(suites)
	return allTests

if __name__ == "__main__":
	unittest.main()
