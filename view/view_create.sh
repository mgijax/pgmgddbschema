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
CRS_create.logical \
MRK_create.logical \
HMD_create.logical \
IMG_create.logical \
MAP_create.logical \
MGI_create.logical \
MLC_create.logical \
RI_create.logical \
MLD_create.logical \
DAG_create.logical \
NOM_create.logical \
SEQ_create.logical \
GO_create.logical
do
$i $*
done

