#!/bin/sh

cd `dirname $0` && . ../Configuration

./comments.py
chmod 775 ${PG_MGD_DBSCHEMADIR}/comments/*object

