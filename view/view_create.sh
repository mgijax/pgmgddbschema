#!/bin/sh

#
# Object Group Script
#
# Executes all *_create.logical scripts
#

cd `dirname $0` && . ./Configuration

for i in \
BIB_create.logical \
VOC_create.logical \
GXD_create.logical \
PRB_create.logical \
ACC_create.logical \
ALL_create.logical \
MRK_create.logical \
IMG_create.logical \
MAP_create.logical \
MGI_create.logical \
MLD_create.logical \
DAG_create.logical \
SEQ_create.logical \
BIB_GOXRef_View_create.object \
BIB_AssociatedData_View_create.object
do
$i $*
done

