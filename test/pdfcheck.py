'''
#
# Check if BIB_Workflow_Data.hasPDF = 1 
# then PDF file really exists in ${LITTRIAGE_MASTER}
#
'''
 
import sys 
import os
import db

mgiLookup = []

db.setTrace()

def checkMGDToPDF():

    global mgiLookup

    outFile = open('pdfcheck.out', 'w')

    results = db.sql('''
    select d._Refs_key, a.numericPart
    from BIB_Workflow_Data d, ACC_Accession a
    where d.hasPDF = 1 
    and d._Refs_key = a._Object_key
    and a._MGIType_key = 1
    and a._LogicalDB_key = 1
    and a.prefixPart = 'MGI:'
    and a.preferred = 1
    ;
    ''', 'auto')

    for r in results:
        outFile.write(str(r['numericPart']) + '.pdf\n')
    mgiLookup.append(r['numericPart'])

    outFile.close()

    return 0

def checkPDFToMGD():

    #print mgiLookup

    rootdir = os.getenv('LITTRIAGE_MASTER')

    print(rootdir)

    for dirs, subdirs, files in os.walk(rootdir):
        for file in files:
	        mgiId = file
	        mgiId = mgiId.replace('.pdf', '')
	        if mgiId not in mgiLookup:
	            print(mgiId)

    return 0

#
# main
#

checkMGDToPDF()

try:
    if sys.argv[1] == 'checkPDFToMGD':
        checkPDFToMGD()
except:
    pass

