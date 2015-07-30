#!/bin/sh

#
# Script to call all unbind and drop sh scripts
# Order is important!
#

cd `dirname $0`

foreach i (view procedure trigger index key table)
cd $i
foreach j (*_drop.sh)
$j $*
end
cd ..
end

