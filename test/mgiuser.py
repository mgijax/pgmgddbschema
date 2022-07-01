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

db.setTrace()

#
# Main
#

db.useOneConnection(1)

results = db.sql('select _user_key, login, name from mgi_user order by _user_key', 'auto')

usersql = ""
for r in results:
    usersql += "delete from mgi_user where _user_key = " + str(r['_user_key']) + ";\n"

print(usersql)
db.sql(usersql, None)
db.commit()
db.useOneConnection(0)

