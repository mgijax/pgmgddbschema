import unittest
import psycopg2
import SybaseProcedureLookup
from translatesp import Translator

# common values and methods for all the following test suites
class CommonProcedureLoadTest(object):

	DB_CONN_STRING = "host='mgi-testdb4.jax.org' dbname='pub_dev' user='mgd_dbo' password='db0dev'"

	def setUp(self):
		self.pgConn = psycopg2.connect(self.DB_CONN_STRING)
		self.pgCur = self.pgConn.cursor()
		self.translator = Translator()
		self.procLookup = SybaseProcedureLookup.Lookup("../../mgddbschema/procedure")

	def tearDown(self):
		self.pgCur.close()
		self.pgConn.close()

	# read sybase procedure from file, run the translator and load it into the pg database
	def translateAndLoadProc(self,procName):
		procedureSQL = self.getProcByName(procName)
		translation = self.translator.translate(procedureSQL)
		translation = translation.replace('\\$','$')
		translation = translation.replace('EOSQL','')
		self.pgCur.execute(translation)

	def getProcByName(self,procName):
		return self.procLookup.get(procName)

	# shared functions for inserting fake data 
	def insertFakeAccessionRecord(self,accKey,mgiTypeKey=1,objectKey=1,accid="test",logicalDbKey=1):
		insertSQL = """
			insert into acc_accession 
			(_accession_key,accid,_logicaldb_key,_object_key,_mgitype_key,private, 
				_createdby_key,_modifiedby_key,creation_date,modification_date) 
			values (%d,'%s',%d,%d,%d,1,1001,1001,now(),now())
			"""%(accKey,accid,logicalDbKey,objectKey,mgiTypeKey)
		self.pgCur.execute(insertSQL)

	def insertFakeMarkerRecord(self,mrkKey):
		insertSQL = """
			insert into mrk_marker
			(_marker_key,_organism_key,_marker_status_key,_marker_type_key,_curationstate_key,
				symbol,name,chromosome,_createdby_key,_modifiedby_key,creation_date,modification_date)
			values (%d,1,1,1,107,'test','test','1',1001,1001,now(),now())
			"""%(mrkKey)
		self.pgCur.execute(insertSQL)

	def insertFakeProbeRecord(self,prbKey,name='test'):
		insertSQL = """
			insert into prb_probe
			(_probe_key,name,_source_key,_vector_key,_segmenttype_key,
				_createdby_key,_modifiedby_key,creation_date,modification_date) 
			values (%d,'%s',107,107,107,1001,1001,now(),now())
			"""%(prbKey,name)
		self.pgCur.execute(insertSQL)

	def insertFakeReferenceRecord(self,refKey,journal='T'):
		insertSQL = """insert into bib_refs
			(_refs_key,_reviewstatus_key,reftype,nlmstatus,isreviewarticle,journal,
				_createdby_key,_modifiedby_key,creation_date,modification_date) 
			values (%d,1,'T','T',1,'%s',1001,1001,now(),now())
			"""%(refKey,journal)
		self.pgCur.execute(insertSQL)

	def insertFakeBibCitationCache(self,refKey,jnumId='T'):
		insertSQL = """
			insert into bib_citation_cache
			(_refs_key,numericpart,jnumid,mgiid,reviewstatus,citation,short_citation,
				isreviewarticle,isreviewarticlestring)
			values(%d,1,'%s','T','T','T','T',1,'T')
			"""%(refKey,jnumId)
		self.pgCur.execute(insertSQL)

	def insertFakeVocTerm(self,termKey,term,vocabKey=2):
		insertSQL = """
			insert into voc_term
			(_term_key,_vocab_key,term,isobsolete,
				_createdby_key,_modifiedby_key,creation_date,modification_date)
			values (%d,%d,'%s',0,1001,1001,now(),now())
			"""%(termKey,vocabKey,term)
		self.pgCur.execute(insertSQL)

	def insertFakeNote(self,noteKey,objectKey,note,mgiTypeKey=1,noteTypeKey=1):
		insertSQL = """
			insert into mgi_note
			(_note_key,_object_key,_mgitype_key,_notetype_key,
				_createdby_key,_modifiedby_key,creation_date,modification_date)
			values (%d,%d,%d,%d,1001,1001,now(),now())
			"""%(noteKey,objectKey,mgiTypeKey,noteTypeKey)
		self.pgCur.execute(insertSQL)

		# insert the chunk
		insertSQL = """
			insert into mgi_notechunk
			(_note_key,sequencenum,note,
				_createdby_key,_modifiedby_key,creation_date,modification_date)
			values (%d,1,'%s',1001,1001,now(),now())
			"""%(noteKey,note)
		self.pgCur.execute(insertSQL)

# Test that these procedures can be loaded by the translator
class SimpleProcedureLoadTest(unittest.TestCase,CommonProcedureLoadTest):

	def setUp(self):
		CommonProcedureLoadTest.setUp(self)

	def tearDown(self):
		CommonProcedureLoadTest.tearDown(self)

	### Tests ###
	def testACCRef_insert(self):
		self.translateAndLoadProc("ACCRef_insert")

	def testACC_setMax(self):
		self.translateAndLoadProc("ACC_setMax")

	def testACC_split(self):
		self.translateAndLoadProc("ACC_split")

	def testALL_mergeAllele(self):
		self.translateAndLoadProc("ALL_mergeAllele")

	def testBIB_getCopyright(self):
		self.translateAndLoadProc("BIB_getCopyright")

	def testGXD_removeBadGelBand(self):
		self.translateAndLoadProc("GXD_removeBadGelBand")

	def testMAP_deleteByCollection(self):
		self.translateAndLoadProc("MAP_deleteByCollection")

	def testMGI_Table_Column_Cleanup(self):
		self.translateAndLoadProc("MGI_Table_Column_Cleanup")

	def testMGI_checkUserRole(self):
		self.translateAndLoadProc("MGI_checkUserRole")

	def testMGI_insertReferenceAssoc(self):
		self.translateAndLoadProc("MGI_insertReferenceAssoc")

	def testMGI_insertSynonym(self):
		self.translateAndLoadProc("MGI_insertSynonym")

	def testMRK_deleteIMAGESeqAssoc(self):
		self.translateAndLoadProc("MRK_deleteIMAGESeqAssoc")

	def testMRK_insertHistory(self):
		self.translateAndLoadProc("MRK_insertHistory")

	def testMRK_updateIMAGESeqAssoc(self):
		self.translateAndLoadProc("MRK_updateIMAGESeqAssoc")

	def testMRK_updateOffset(self):
		self.translateAndLoadProc("MRK_updateOffset")

	def testNOM_updateReserved(self):
		self.translateAndLoadProc("NOM_updateReserved")

	def testPRB_insertReference(self):
		self.translateAndLoadProc("PRB_insertReference")

	def testPRB_reloadSequence(self):
		self.translateAndLoadProc("PRB_reloadSequence")

	def testSEQ_loadMarkerCache(self):
		self.translateAndLoadProc("SEQ_loadMarkerCache")

	def testSEQ_loadProbeCache(self):
		self.translateAndLoadProc("SEQ_loadProbeCache")

	def testVOC_mergeAnnotations(self):
		self.translateAndLoadProc("VOC_mergeAnnotations")

	def testVOC_mergeTerms(self):
		self.translateAndLoadProc("VOC_mergeTerms")


# specifically test the behavior of the ACCRef_insert procedure
class ACCRefInsertTest(unittest.TestCase,CommonProcedureLoadTest):
	
	def setUp(self):
		# call the common setUp first
		CommonProcedureLoadTest.setUp(self)
		# load the translated ACCRef_insert procedure
		self.translateAndLoadProc("ACCRef_insert")

	def tearDown(self):
		CommonProcedureLoadTest.tearDown(self)

	### TESTS ###

	def testSimpleInsert(self):
		accKey = 999999999
		refKey = 999999999
		self.insertFakeAccessionRecord(accKey,mgiTypeKey=1)
		self.insertFakeReferenceRecord(refKey)

		# call the procedure
		self.pgCur.execute("select ACCRef_insert(%d,%d)"%(accKey,refKey))

		# verify that the record was inserted
		selectSQL = """select count(*) from acc_accessionreference 
			where _accession_key=%d
				and _refs_key=%d
			"""%(accKey,refKey)
		self.pgCur.execute(selectSQL)
		self.assertEquals(1,self.pgCur.fetchone()[0])

# specifically test the behavior of the MRK_deleteIMAGESeqAssoc procedure
class MRK_deleteIMAGESeqAssocTest(unittest.TestCase,CommonProcedureLoadTest):
	
	def setUp(self):
		# call the common setUp first
		CommonProcedureLoadTest.setUp(self)
		# load the translated MRK_deleteIMAGESeqAssoc procedure
		self.translateAndLoadProc("MRK_deleteIMAGESeqAssoc")

	def tearDown(self):
		CommonProcedureLoadTest.tearDown(self)

	def insertProbeMarkerRelationship(self,prbKey,mrkKey,refKey=1001,relationship='E'):
		insertSQL = """
		insert into prb_marker
		(_probe_key,_marker_key,_refs_key,relationship,
			_createdby_key,_modifiedby_key,creation_date,modification_date)
		values (%d,%d,%d,'%s',1001,1001,now(),now())
		"""%(prbKey,mrkKey,refKey,relationship)
		self.pgCur.execute(insertSQL)

	### TESTS ###

	def testStandardDelete(self):
		accKey = 999999999
		mrkKey = 999999999
		prbKey = 999999999
		accid = "testPrbMrk"

		# make fake probe and marker
		self.insertFakeMarkerRecord(mrkKey)
		self.insertFakeProbeRecord(prbKey,name="IMAGE clone")

		# insert relationship
		self.insertProbeMarkerRelationship(prbKey,mrkKey)

		# attach accid to probe
		self.insertFakeAccessionRecord(accKey,mgiTypeKey=3,logicalDbKey=9,accid=accid,objectKey=prbKey)


		# call the procedure
		self.pgCur.execute("select MRK_deleteIMAGESeqAssoc(%d,'%s')"%(mrkKey,accid))

		# verify that the relationship was deleted
		selectSQL = """select count(*) from prb_marker
			where _probe_key=%d
				and _marker_key=%d
			"""%(prbKey,mrkKey)
		self.pgCur.execute(selectSQL)
		self.assertEquals(0,self.pgCur.fetchone()[0])

# specifically test the behavior of the BIB_getCopyright procedure
class BIB_getCopyrightTest(unittest.TestCase,CommonProcedureLoadTest):
	
	def setUp(self):
		# call the common setUp first
		CommonProcedureLoadTest.setUp(self)

		# globals		
		self.journalVocabKey = 48
		self.termMgiTypeKey = 13
		self.termNoteType = 1026

		# load the translated BIB_getCopyright procedure
		self.translateAndLoadProc("BIB_getCopyright")

	def tearDown(self):
		CommonProcedureLoadTest.tearDown(self)

	### TESTS ###

	def testDefault(self):
		refKey = 999999999
		termKey = 999999999
		noteKey = 999999999
		journal = 'test journal'
		note = 'test note'
		
		self.insertFakeReferenceRecord(refKey,journal=journal)
		self.insertFakeBibCitationCache(refKey)
		self.insertFakeVocTerm(termKey,journal,vocabKey=self.journalVocabKey)
		self.insertFakeNote(noteKey,termKey,note,mgiTypeKey=self.termMgiTypeKey,noteTypeKey=self.termNoteType)

		# call the procedure
		self.pgCur.execute("select BIB_getCopyright(%d)"%(refKey))

		# verify that it returns the default, which is the journal note
		self.assertEquals('test note',self.pgCur.fetchone()[0].strip())

	def testElsevierNote(self):
		refKey = 999999999
		termKey = 999999999
		noteKey = 999999999
		journal = 'test journal'
		note = 'Elsevier()'
		jnumid = 'testJnum'
		
		self.insertFakeReferenceRecord(refKey,journal=journal)
		self.insertFakeBibCitationCache(refKey)
		self.insertFakeVocTerm(termKey,journal,vocabKey=self.journalVocabKey)
		self.insertFakeNote(noteKey,termKey,note,mgiTypeKey=self.termMgiTypeKey,noteTypeKey=self.termNoteType)

		# call the procedure
		self.pgCur.execute("select BIB_getCopyright(%d)"%(refKey))

		# verify that it returns the default, which is the journal note
		self.assertEquals('Elsevier(testJnum)',self.pgCur.fetchone()[0].strip())

def suite():
	suitesToRun = [
		SimpleProcedureLoadTest,
		ACCRefInsertTest,
		MRK_deleteIMAGESeqAssocTest,
		BIB_getCopyrightTest
	]
	suites = [unittest.TestLoader().loadTestsFromTestCase(ts) for ts in suitesToRun]
	allTests = unittest.TestSuite(suites)
	return allTests

if __name__ == "__main__":
	unittest.main()
