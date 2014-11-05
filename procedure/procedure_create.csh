#!/bin/csh -f

#
# Object Group Script
#
# Executes all *_create.logical scripts
#
# Order is important!
#

cd `dirname $0`

foreach i (\
*_create.object
)
$i $*
end

