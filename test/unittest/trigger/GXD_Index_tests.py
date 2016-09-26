"""
    Test triggers on GXD_Index table

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

	def test_update_propertyconditional(self):
	    '''
	    update the priority/conditional mutant
	    for an existing index record

	    verify that *all* priority/conditional mutant values 
	    for same reference is modified
	    '''

	    r = db.sql('''
		    select i
		    from BIB_Citation_Cache r, GXD_Index i
		    where r.jnumID in ('J:12603')
		    and r._Refs_key = i._Refs_key
		    and i._Priority_key != 74716
		    ;
		    ''', 'auto')
            before_count = len(r)

	    db.sql('''
		update GXD_Index 
		set _Priority_key = 74716, 
		    _ConditionalMutants_key = 4834242
		where _Index_key = 1327;
		''', None)
    
	    r = db.sql('''
		    select i
		    from BIB_Citation_Cache r, GXD_Index i
		    where r.jnumID in ('J:12603')
		    and r._Refs_key = i._Refs_key
		    and i._Priority_key = 74716
		    ;
		    ''', 'auto')
            after_count = len(r)

	    self.assertTrue((before_count == after_count), 'updated priority/conditional')

	    db.sql('''
		update GXD_Index 
		set _Priority_key = 74714, 
		    _ConditionalMutants_key = 4834242
		where _Index_key = 1327;
		''', None)
    
	    r = db.sql('''
		    select i
		    from BIB_Citation_Cache r, GXD_Index i
		    where r.jnumID in ('J:12603')
		    and r._Refs_key = i._Refs_key
		    and i._Priority_key != 74716
		    ;
		    ''', 'auto')
            before_count = len(r)

	    self.assertTrue((before_count == after_count), 'updated priority/conditional')

	def test_add_noexistingref(self):
	    '''
	    add new index record using reference that has no existing records
	    '''

	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r.jnumID in ('J:12603')
	    	    and r._Refs_key = i._Refs_key
	    	    and i._Marker_key = 27555
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((0 == check_count), 'an index for this reference should not exist')

            self.insert_index(12567,27555,'null')

	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r.jnumID in ('J:12603')
	    	    and r._Refs_key = i._Refs_key
	    	    and i._Marker_key = 27555
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'new reference/index did not get added')

	    db.sql('''
	        delete from GXD_Index 
		where _Index_key = (select max(_Index_key) from GXD_Index) 
	        and _Refs_key = 12567
	        and _Marker_key = 27555
	    	''', None)

	    r = db.sql('''
	    	    select i.* 
	    	    from BIB_Citation_Cache r, GXD_Index i
	    	    where r.jnumID in ('J:12603')
	    	    and r._Refs_key = i._Refs_key
	    	    and i._Marker_key = 27555
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((0 == check_count), 'new reference/index did not get deleted')

	def test_add_existingref(self):
	    '''
	    add new index record using reference that has existing records
	    '''

	    r = db.sql('''
	    	    select r.* 
		    from BIB_Citation_Cache r
		    where r.jnumID in ('J:1')
		    and not exists (select 1 from GXD_Index i where r._Refs_key = i._Refs_key)
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'an index for this reference should not exist')

	    args = [75786, 12180, 'null']
            self.assertRaises(DbManagerError, self.insert_index, *args)

            self.insert_index(75786,12180,74714)

	    r = db.sql('''
	            select i.* 
	            from BIB_Citation_Cache r, GXD_Index i
	            where r.jnumID in ('J:1')
	            and r._Refs_key = i._Refs_key
	            ;
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((1 == check_count), 'new reference/index did not get added')

	    db.sql('''
		delete from GXD_Index where _Refs_key = 75786;
	        ''', None)

	    r = db.sql('''
	            select i.* 
	            from BIB_Citation_Cache r, GXD_Index i
	            where r.jnumID in ('J:1')
	            and r._Refs_key = i._Refs_key
	            ;
	    	    ''', 'auto')
            check_count = len(r)
	    self.assertTrue((0 == check_count), 'new reference/index did not get deleted')

	# helper functions

	def insert_index(self, _refs_key, _marker_key, _priority_key):
	    '''
	    insert a new GXD_Index record
	    '''

	    db.sql('''
	        insert into GXD_Index values((select max(_Index_key) + 1 from GXD_Index), 
		    %s, %s, %s, null, null, 1000, 1000, now(), now())
		;
	    	''' % (_refs_key, _marker_key, _priority_key), None)

def suite():
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(InsertUpdateTest))
    return suite

if __name__ == '__main__':
    unittest.main()
