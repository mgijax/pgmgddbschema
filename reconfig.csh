#!/bin/csh -f

#
# Drop and re-create database triggers, stored procedures and views
# grant permissions
#

cd `dirname $0` && source ./Configuration

rm ./logs/default/*.log
./default/default_unbind.csh
./default/default_bind.csh

rm ./logs/key/*.log
./key/key_drop.csh
./key/key_create.csh

rm ./logs/view/*.log
./view/view_drop.csh
./view/view_create.csh

rm ./logs/procedure/*.log
./procedure/procedure_drop.csh
./procedure/procedure_create.csh

rm ./logs/trigger/*.log
./trigger/trigger_drop.csh
./trigger/trigger_create.csh

./all_perms.csh

