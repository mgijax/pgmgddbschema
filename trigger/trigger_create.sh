#!/bin/sh

#
# Object Group Script
#
# Executes all *_create.logical scripts
#

cd `dirname $0` && . ./Configuration

for i in *_delete_create.object *_insert_create.object *_update_create.object
do
$i $*
done

