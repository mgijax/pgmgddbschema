#!/bin/csh -f -x

#
# Script to call all bind and create csh scripts
# Order is important!
#

cd `dirname $0`

foreach i (table key index view procedure trigger)
cd $i
foreach j (*_create.csh)
$j $*
end
cd ..
end

