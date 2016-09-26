"""
Run all pgmgddbschema trigger test suites
"""

import sys
import unittest

import MGI_SetMember_EMAPA_tests
import GXD_Index_tests

# add the test suites
def suite():
	suites = []
	suites.append(MGI_SetMember_EMAPA_tests.suite())
	suites.append(GXD_Index_tests.suite())
	
	master_suite = unittest.TestSuite(suites)
	return master_suite

if __name__ == '__main__':
	test_suite = suite()
	runner = unittest.TextTestRunner()
	
	ret = not runner.run(test_suite).wasSuccessful()
	sys.exit(ret)

