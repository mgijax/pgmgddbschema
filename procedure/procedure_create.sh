#!/bin/sh

#
# Object Group Script
#
# Executes all *_create.logical scripts
#
# Order is important!
#

cd `dirname $0` && . ./Configuration

for i in *create.object
do
$i $*
done

# assignJ may need to be re-run because it may not be successful unitl assignMGI exists
# ACC_assignJ_create.object
