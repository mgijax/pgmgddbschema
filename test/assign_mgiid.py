#!/usr/local/bin/python

'''
# delete old mgi ids
# assign new mgi ids
'''
 
import sys 
import os
import db

db.setTrace()

cmd = '''
WITH mgiid AS
(
select accid from acc_accession 
where _logicaldb_key = 1 
and prefixpart = 'MGI:' 
and numericpart >= 5913948 
and _mgitype_key not in (25)
group by accid 
having count(*) > 1 
)
select a._accession_key, a.accid, a._logicaldb_key, a._object_key, a._mgitype_key, a._createdby_key, a.creation_date
from acc_accession a, mgiid m
where m.accid = a.accid
and a._mgitype_key = 10
'''

deleteSQL = ''
addSQL = ''

results = db.sql(cmd, 'auto')

for r in results:
   print r
   deleteSQL = "delete from acc_accession where _accession_key = " + str(r['_accession_key']) + ";"
   print deleteSQL
   db.sql(deleteSQL, None)
   db.commit()
   addSQL = "select * from ACC_assignMGI(1000, " + str(r['_object_key']) + ", 'Strain');"
   print addSQL
   db.sql(addSQL, None)
   db.commit()

