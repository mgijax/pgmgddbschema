#!/bin/sh

#
# Script to call all bind and create sh scripts
# Order is important!
#

cd `dirname $0`

foreach i (table key index view procedure trigger)
cd $i
foreach j (*_create.sh)
$j $*
end
cd ..
end

