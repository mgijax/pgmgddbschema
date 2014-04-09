#!/bin/csh -f

#
# Script to call all unbind and drop csh scripts
# Order is important!
#

cd `dirname $0`

foreach i (view procedure trigger index key table)
cd $i
foreach j (*_drop.csh)
$j $*
end
cd ..
end

