#!/bin/csh

foreach i (*.object)
echo $i
ed $i <<END
g/\${PG_MGD_DBSERVER} /s///g
g/\${PG_MGD_DBNAME} /s///g
.
w
q
END
end

