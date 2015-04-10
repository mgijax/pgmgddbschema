#!/bin/sh

#
# Object Group Script
#
# Executes all *_drop.object
#

cd `dirname $0` && . ./Configuration

for i in *drop.object
do
echo $i
$i
done

