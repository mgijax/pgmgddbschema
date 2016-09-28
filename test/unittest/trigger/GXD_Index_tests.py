"""
    Test triggers on GXD_Index table

    see trigger/GXD_Index_create.object for more details
"""

import unittest

import db
from dbManager import DbManagerError
db.useOneConnection(1)

class InsertUpdateTest(unittest.TestCase):
	"""
	Test insert / update records
	"""

	### Test updates ###

	def test_update(self):
	    '''
	    update the priority/conditional mutant
	    for an existing index record

	    verify that *all* priority/conditional mutant values 
	    for same reference is modified
	    '''

	    r = db.sql('''
		    select i.*
		    from BIB_Citation_Cache r, GXD_Index i
		    where r._Refs_key = 12567
		    and r._Refs_key = i._Refs_key
		    and i._Priority_key != 74716
		    and i._ConditionalMutants_key != 4834243
		    ''', 'auto')
            before_count = len(r)

	    #####
	    # update priority/conditional

	    db.sql('''
		update GXD_Index 
		set _Priority_key = 74716, 
		    _ConditionalMutants_key = 4834243
		where _Index_key = 1327
		''', None)
    
	    # count of new values should match count of old values
	    r = db.sql('''
		    select i.*
		    from BIB_Citation_Cache r, GXD_Index i
		    where r._Refs_key = 12567
		    and r._Refs_key = i._Refs_key
		    and i._Priority_key = 74716
		    and i._ConditionalMutants_key = 4834243
		    ''', 'auto')
            after_count = len(r)

	    self.assertTrue((before_count == after_count), 'updated priority/conditional')

	    # change back to original values
	    db.sql('''
		update GXD_Index 
		set _Priority_key = 74714, 
		    _ConditionalMutants_key = 4834242
		where _Index_key = 1327
		''', None)

	    # count of restored values should match count of new values
	    r = db.sql('''
		    select i.*
		    from BIB_Citation_Cache r, GXD_Index i
		    where r._Refs_key = 12567
		    and r._Refs_key = i._Refs_key
		    and i._Priority_key != 74716
		    and i._ConditionalMutants_key != 4834243
		    ''', 'auto')
            before_count = len(r)

	    self.assertTrue((before_count == after_count), 'updated priority/conditional')

	def test_add_noexistingref(self):
	    '''
	    add new index record using reference that has no existing index records
	    '''

	    r = db.sql('''
	    	    select r.* 
		    from BIB_Citation_Cache r
	    	    where r._Refs_key = 75786
		    and not exists (select 1 from GXD_Index i where r._Refs_key = i._Refs_key)
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'an index for this reference should not exist')

	    #####

	    # add new index record; priority is null; conditional is null; should return exception in trigger
	    args = [75786,12180,'','']
            self.assertRaises(DbManagerError, self.insert_index, *args)

	    # add new index record; priority is null; conditional is not null; should return exception in trigger
	    args = [75786,12181,'',4834243]
            self.assertRaises(DbManagerError, self.insert_index, *args)

	    #####

	    # add new index record; priority is not null; conditional is not null
            self.insert_index(75786,12182,74716,4834243)

	    # check that new index record exists
	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r._Refs_key = 75786
	    	    and r._Refs_key = i._Refs_key
		    and i._Marker_key = 12182
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'new index record; priority not null; conditional not null')

	    # add new index record; priority is not null; conditional is null
            self.insert_index(75786,12183,74716,'')

	    # check that new index record exists
	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r._Refs_key = 75786
	    	    and r._Refs_key = i._Refs_key
		    and i._Marker_key = 12183
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'new index record; priority not null; conditional null')

	    ###

	    # delete test index records
	    db.sql('''
	        delete from GXD_Index 
		where _Refs_key = 75786
	        and _Marker_key in (12180,12181,12182,12183)
	    	''', None)

	    # check that new index record has been deleted
	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r._Refs_key = 75786
	    	    and r._Refs_key = i._Refs_key
	    	    and i._Marker_key in (12180,1218,12182,12183)
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((0 == check_count), 'new reference/index did not get deleted')

	def test_add_existingref(self):
	    '''
	    add new index record using reference that has existing index records
	    '''

	    r = db.sql('''
	    	    select r.* 
		    from BIB_Citation_Cache r
		    where r._Refs_key = 12567
                    and exists (select 1 from GXD_Index i where r._Refs_key = i._Refs_key)
		    ;
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'an index for this reference must exist')

	    #####

	    # add new index record; priority is null; conditional is null
            self.insert_index(12567,12180,'','')

	    r = db.sql('''
	            select i.* 
	            from BIB_Citation_Cache r, GXD_Index i
	            where r._Refs_key = 12567
	            and r._Refs_key = i._Refs_key
		    and i._Marker_key = 12180
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'new index record; priority is null; conditional is null')

	    #####

	    # add new index record; priority is not null; conditional is not null
            self.insert_index(12567,12181,74714,4834243)

	    r = db.sql('''
	            select i.* 
	            from BIB_Citation_Cache r, GXD_Index i
	            where r._Refs_key = 12567
	            and r._Refs_key = i._Refs_key
	    	    and i._Marker_key = 12181
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'new index record; priority not null; conditional is not null')

	    #####

	    # delete test index records
	    db.sql('''
	        delete from GXD_Index 
		where _Refs_key = 12567
	    	and _Marker_key in (12180,12181)
	        ''', None)

	    # check that new index record has been deleted
	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r._Refs_key = 12567
	    	    and r._Refs_key = i._Refs_key
	    	    and i._Marker_key in (12180,12181)
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((0 == check_count), 'new index records; did not get deleted')

	# helper functions

	def insert_index(self, _refs_key, _marker_key, _priority_key = '', _conditionalmutant_key = ''):
	    '''
	    insert a new GXD_Index record
	    '''

	    if _priority_key == '' and _conditionalmutant_key == '':
	        db.sql('''
	            insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
		        %s, %s, null, null, null, 1000, 1000, now(), now())
	    	    ''' % (_refs_key, _marker_key), None)
	    elif _priority_key == '':
	        db.sql('''
	            insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
		        %s, %s, null, %s, null, 1000, 1000, now(), now())
	    	    ''' % (_refs_key, _marker_key, _conditionalmutant_key), None)
	    elif _conditionalmutant_key == '':
	        db.sql('''
	            insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
		        %s, %s, %s, null, null, 1000, 1000, now(), now())
	    	    ''' % (_refs_key, _marker_key, _priority_key), None)
            else:
	        db.sql('''
	            insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
		        %s, %s, %s, %s, null, 1000, 1000, now(), now())
	    	    ''' % (_refs_key, _marker_key, _priority_key, _conditionalmutant_key), None)

def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(InsertUpdateTest))
    return suite

if __name__ == '__main__':
    unittest.main()
