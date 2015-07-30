#!/bin/sh

#
# Drop and re-create database triggers, stored procedures and views
# grant permissions
#

cd `dirname $0` && source ./Configuration

rm ./logs/key/*.log
./key/key_drop.sh
./key/key_create.sh

rm ./logs/view/*.log
./view/view_drop.sh
./view/view_create.sh

rm ./logs/procedure/*.log
./procedure/procedure_drop.sh
./procedure/procedure_create.sh

rm ./logs/trigger/*.log
./trigger/trigger_drop.sh
./trigger/trigger_create.sh

