
# only run on TEST server first!
# this will clea up/delete MGI_User that are not used elsewhere in the database
# it will use foreign key constrains to skip/ignore/*not* delete a MGI_User
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
    usersql = "delete from mgi_user where _user_key = " + str(r['_user_key']) + ";\n"
    try:
            print(usersql)
            #db.sql(usersql, None)
            db.commit()
    except:
            print('user is being used: ', str(r['_user_key']))

db.useOneConnection(0)

