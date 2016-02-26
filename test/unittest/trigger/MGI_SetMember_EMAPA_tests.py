"""
    Test triggers on MGI_SetMember_EMAPA table

    Requires:
	data in MGI_User (_user_key=1211 for unknown editor)
	data in MGI_Set (_set_key=1046 for EMAPA clipboard)
	data in VOC_Term_EMAPA 
"""

import unittest

import db
from dbManager import DbManagerError
db.useOneConnection(1)

# use unknown editor for testing
USER_KEY = 1211

# Use Stage/EMAPA set
SET_KEY = 1046

# get a valid EMAPA term to test with
#	preferrably one we can go 
#	above and below the valid range
r = db.sql("""
	select _term_key, startstage, endstage
	from VOC_Term_EMAPA
	where (endstage - startstage) > 4
	and startstage > 1
	and endstage < 28
	limit 1
	""", 'auto')
if not r:
	raise Error("Could not locate VOC_Term_EMAPA test data")
TERM1 = r[0]


class InsertUpdateTest(unittest.TestCase):
	"""
	Test insert / update of MGI_SetMember_EMAPA records
	"""

	def tearDown(self):
		"""
		Clear any inserted data
		"""
		db.sql('delete from MGI_SetMember where _createdby_key = %d' % USER_KEY, None)
	

	### Test Inserts ###

	def test_add_valid_stage(self):
		_setmember_key = self.addEMAPATerm(TERM1["_term_key"])
		
		validStage = TERM1["startstage"] + 1
		self.addEMAPAStage(_setmember_key, validStage)


	def test_add_stage_greater_than_range(self):
		"""
		Stage being added exceeds valid range for the associated EMAPA term
		"""
		_setmember_key = self.addEMAPATerm(TERM1["_term_key"])
		
		with self.assertRaises(DbManagerError):
		    # add stage 28, which is outside range
		    self.addEMAPAStage(_setmember_key, 28)

	def test_add_stage_lower_than_range(self):
		"""
		Stage being added is lower than valid range for the associated EMAPA term
		"""
		_setmember_key = self.addEMAPATerm(TERM1["_term_key"])
		
		with self.assertRaises(DbManagerError):
		    # add stage 1, which is outside range
		    self.addEMAPAStage(_setmember_key, 1)


	def test_add_multiple_stages_for_clipboard_item(self):
		"""
		It is not allowed to add multiple stage rows for
			 a single clipboard item
		"""
		_setmember_key = self.addEMAPATerm(TERM1["_term_key"])

		validStage1 = TERM1["startstage"] + 1
		validStage2 = TERM1["startstage"] + 1
		self.addEMAPAStage(_setmember_key, validStage1)
		
		with self.assertRaises(DbManagerError):
		    # add a second stage for the same set member
		    self.addEMAPAStage(_setmember_key, validStage2)


	def test_add_duplicate_clipboard_item(self):
		"""
		Inserting a duplicate clipboard item should remove the 
			old record that matches, leaving the new one
		"""
		validStage1 = TERM1["startstage"] + 1

		# add a single clipboard record
		_setmember_key1 = self.addEMAPATerm(TERM1["_term_key"])
		self.addEMAPAStage(_setmember_key1, validStage1)

		# add the same record again
		_setmember_key2 = self.addEMAPATerm(TERM1["_term_key"])
		self.addEMAPAStage(_setmember_key2, validStage1)

		# first record should be removed from database
		r = db.sql("""
			select 1 from MGI_SetMember 
			where _setmember_key = %d
		""" % (_setmember_key1), 'auto')

		self.assertEqual(0, len(r), "first dup should be removed")

		# second should still exist
		r = db.sql("""
			select 1 from MGI_SetMember 
			where _setmember_key = %d
		""" % (_setmember_key2), 'auto')

		self.assertEqual(1, len(r), "new record should still exist")
		

	### Test updates ###

	def test_update_valid_stage(self):
		_setmember_key = self.addEMAPATerm(TERM1["_term_key"])
		
		validStage1 = TERM1["startstage"] + 1
		validStage2 = TERM1["startstage"] + 2
		_setmember_emapa_key = self.addEMAPAStage(_setmember_key, validStage1)

		self.updateEMAPAStage(_setmember_emapa_key, validStage2)


	def test_update_stage_outside_range(self):
		"""
		Stage being updated exceeds valid range for the associated EMAPA term
		"""
		_setmember_key = self.addEMAPATerm(TERM1["_term_key"])
		validStage = TERM1["startstage"] + 1
		_setmember_emapa_key = self.addEMAPAStage(_setmember_key, validStage)

		with self.assertRaises(DbManagerError):
		    # add stage 28, which is outside range
		    self.updateEMAPAStage(_setmember_emapa_key, 28)

	def test_update_creates_duplicate_clipboard_item(self):
		"""
		Updating a record to create a duplicate clipboard item should remove the 
			old record that matches, leaving the new one
		"""
		validStage1 = TERM1["startstage"] + 1
		validStage2 = TERM1["startstage"] + 2

		# add two clipboard items for the same term
		#	but at different stages
		_setmember_key1 = self.addEMAPATerm(TERM1["_term_key"])
		_setmember_emapa_key1 = self.addEMAPAStage(_setmember_key1, validStage1)
		_setmember_key2 = self.addEMAPATerm(TERM1["_term_key"])
		_setmember_emapa_key2 = self.addEMAPAStage(_setmember_key2, validStage2)

		# now update the second stage match the first.
		#	this will create a duplicate
		self.updateEMAPAStage(_setmember_emapa_key2, validStage1)

		# first record should be removed from database
		r = db.sql("""
			select 1 from MGI_SetMember 
			where _setmember_key = %d
		""" % (_setmember_key1), 'auto')

		self.assertEqual(0, len(r), "first dup should be removed")

		# second should still exist
		r = db.sql("""
			select 1 from MGI_SetMember 
			where _setmember_key = %d
		""" % (_setmember_key2), 'auto')

		self.assertEqual(1, len(r), "new record should still exist")


	# helper functions

	def addEMAPATerm(self, _term_key):
		"""
		Adds an MGI_SetMember record
		returns _setmember_key
		"""

		r = db.sql("select max(_setmember_key) maxKey from mgi_setmember", 'auto')
		maxKey = len(r) > 0 and r[0]["maxKey"] or 0
		
		r = db.sql("""
			select max(sequencenum) maxSeqnum from mgi_setmember
			where _createdby_key = %d
		""" % USER_KEY, 'auto')
		seqnum = len(r) > 0 and r[0]["maxSeqnum"] or 0
		db.sql("""
			insert into MGI_SetMember 
			(_setmember_key, _set_key, _object_key, sequencenum, _createdby_key, _modifiedby_key)
			values( %d, %d, %d, %d, %d, %d )
		""" % (maxKey+1, SET_KEY, _term_key, seqnum, USER_KEY, USER_KEY),'auto')

		return maxKey+1

	def addEMAPAStage(self, _setmember_key, stage):
		"""
		Adds an MGI_SetMember_EMAPA record
		returns _setmember_emapa_key
		"""

		r = db.sql("select max(_setmember_emapa_key) maxKey from mgi_setmember_emapa", 'auto')
		maxKey = len(r) > 0 and r[0]["maxKey"] or 0
		
		db.sql("""
			insert into MGI_SetMember_EMAPA
			(_setmember_emapa_key, _setmember_key, _stage_key, _createdby_key, _modifiedby_key)
			values( %d, %d, %d, %d, %d )
		""" % (maxKey+1, _setmember_key, stage, USER_KEY, USER_KEY),'auto')

		return maxKey+1

	def updateEMAPAStage(self, _setmember_emapa_key, stage):
		"""
		Updates _stage_key of _setmember_emapa_key record
		"""

		db.sql("""
			update MGI_SetMember_EMAPA
			set _stage_key = %d
			where _setmember_emapa_key = %d
		""" % (stage, _setmember_emapa_key),None)
	

def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(InsertUpdateTest))
    return suite

if __name__ == '__main__':
    unittest.main()
