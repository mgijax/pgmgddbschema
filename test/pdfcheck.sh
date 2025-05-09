#!/bin/sh

#
# Check if BIB_Workflow_Data.hasPDF = 1
# then PDF file really exists in ${LITTRIAGE_MASTER}
#

cd `dirname $0` && . ./Configuration

LOG=$0.log
rm -rf $LOG
touch $LOG
 
date | tee -a $LOG

${PYTHON} pdfcheck.py | tee -a $LOG

while IFS= read -r line
do
#ls ${LITTRIAGE_MASTER}/*/$line
if [ -f ${LITTRIAGE_MASTER}/*/$line ]
then
  continue
else
  echo $line | tee -a $LOG
fi
done < "pdfcheck.out"

date |tee -a $LOG
