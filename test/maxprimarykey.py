'''
# max primary key
'''
 
import sys 
import os
import db

#db.setTrace()

results = db.sql('''
select
    tc.table_name,
    ccu.column_name
from
    information_schema.tables AS tc,
    information_schema.columns AS ccu ,
    information_schema.constraint_column_usage AS ccu2
where tc.table_name = ccu.table_name
and tc.table_schema = ccu.table_schema
and ccu2.table_name = ccu.table_name
and ccu2.column_name = ccu.column_name
and ccu2.constraint_name = tc.table_name || '_pkey'
order by tc.table_name
''', 'auto')
#and tc.table_name = 'acc_accession'

for r in results:
    results = db.sql('select max(%s) as maxCount from %s' % (r['column_name'], r['table_name']), 'auto')
    maxKey = results[0]['maxCount']

    if maxKey == None:
        continue

    if r['table_name'] == 'mgi_dbinfo':
        continue

    try:
        if int(maxKey) > 1200000000:
            print(maxKey, r['table_name'], r['column_name'])
    except:
        pass

