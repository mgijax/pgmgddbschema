"""
Run all pgmgddbschema test suites
"""

import sys
import unittest

from trigger import all_trigger_tests

# add the test suites
def master_suite():
	suites = []
	suites.append(all_trigger_tests.suite())
	
	master_suite = unittest.TestSuite(suites)
	return master_suite

if __name__ == '__main__':
	test_suite = master_suite()
	runner = unittest.TextTestRunner()
	
	ret = not runner.run(test_suite).wasSuccessful()
	sys.exit(ret)

