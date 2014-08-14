import os

# A Lookup for loading Sybase procedure contents from their create.object scripts on the file system
# Usage: 
# 	Lookup(sybaseProcedureDirectory).get(procedureName)
class Lookup(object):

	procedureSuffix = "_create.object"
	
	def __init__(self,sybaseProcedureDirectory="../procedure"):
		self.procedureDirectory = sybaseProcedureDirectory

	# procedures we will use for tests
	filenames = [
		# Simple cases:
		"ACCRef_insert",
		"ACC_setMax",
		"ACC_split",
		"ACC_verifySequenceAnnotation",
		"ALL_mergeAllele",
		"BIB_getCopyright",
		"GXD_removeBadGelBand",
		"MAP_deleteByCollection",
		"MGI_Table_Column_Cleanup",
		"MGI_checkUserRole",
		"MGI_insertReferenceAssoc",
		"MGI_insertSynonym",
		"MRK_deleteIMAGESeqAssoc",
		"MRK_insertHistory",
		"MRK_updateIMAGESeqAssoc",
		"MRK_updateOffset",
		"NOM_updateReserved",
		"PRB_insertReference",
		"PRB_reloadSequence",
		"SEQ_loadMarkerCache",
		"SEQ_loadProbeCache",
		"VOC_mergeAnnotations",
		"VOC_mergeTerms"
	]

	# parse SQL procedure out of a create object script
	def parseSQLProcedure(self,fileContents):
		# find first go
		gi = fileContents.find("go")
		if gi > 0:
			start = fileContents.find("\n",gi)
			# find second go
			end = fileContents.find("go",start)
			if end > 0:
				# return contents between first two "go" calls
				return fileContents[start:end].strip() + "\n"
		return ""

	# read a file into a string
	def getFileContents(self,filepath):
		contents = ""
		f = open(filepath, "r")
		try:
			contents = f.read()
		finally:
			f.close()
		return contents

	# Load contents of SQL procedure by targetDirectory/filename
	def get(self,filename):
		filename = filename + self.procedureSuffix
		contents = self.getFileContents(os.path.join(self.procedureDirectory,filename))
		return self.parseSQLProcedure(contents)

if __name__ == "__main__":
	lookup = Lookup()
	procedure = "ACCRef_insert"
	print "here are contents of %s:\n%s"%(procedure,lookup.get(procedure))
