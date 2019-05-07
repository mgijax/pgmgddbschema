#!/usr/local/bin/python

#
# Remove obsolete /data/pixeldb JPGs
#

import sys 
import os
import db

mgiLookup = []
pixLookup = []

pixDir = os.getenv('PIXELDB')

db.setTrace()

results = db.sql('''
select distinct a.accID, a.numericPart
from IMG_Image i, ACC_Accession a
where i._Image_key = a._Object_key
and a.prefixPart = 'PIX:'
order by a.numericPart
;
''', 'auto')

for r in results:
    mgiLookup.append(r['numericPart'])

#print mgiLookup

pixLookup = open('pixid.log', 'r')

used = 0
notUsed = 0
for jpgFile in pixLookup:
    pixId = jpgFile.replace('.jpg', '')
    try:
       if int(pixId) in mgiLookup:
           used += 1
       else:
	   notUsed += 1
	   print pixDir + '/' + jpgFile
	   #os.remove(pixDir + '/' + jpgFile)
    except:
       pass

pixLookup.close()

print "not used: ", str(notUsed)
print "used: ", str(used)

