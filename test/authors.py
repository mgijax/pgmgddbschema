#
# Report:
#       Enter TR # and describe report inputs/output
#
# History:
#
# lec	01/18/99
#	- created
#
 
import sys 
import os
import db
import reportlib

db.setTrace()

CRT = reportlib.CRT
SPACE = reportlib.SPACE
TAB = reportlib.TAB
PAGE = reportlib.PAGE

#
# Main
#

db.useOneConnection(1)

results = db.sql('''
select r._refs_key, r._primary, r.authors, r.creation_date, c.jnumid, c.mgiid
from bib_refs r, bib_citation_cache c
where r._refs_key = c._refs_key
and r._primary is not null
and r.authors is not null
''', 'auto')

for r in results:
    tokens = r['authors'].split(';')
    a = tokens[0]
    p = r['_primary']

    if p != a:
        print(r['jnumid'], r['mgiid'], r['creation_date'], 'primary: ', p, ' author: ', a)

db.useOneConnection(0)

