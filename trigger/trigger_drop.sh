#!/bin/sh

#
# Object Group Script
#
# Executes all *_drop.object
#

cd `dirname $0` && . ./Configuration

for i in *_delete_drop.object *insert_drop.object *_update_create.object
do
echo $i
$i
done

