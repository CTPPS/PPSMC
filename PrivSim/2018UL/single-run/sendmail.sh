#!/bin/bash

step=$1
email=`whoami`
TMPDIR=/tmp/

job=$( basename "`ls *.dag`" .dag )

mail -s "${job} :: step ${step} FINISHED" $email <<< "STEP \
${step} HAS FINISHED AND FILES CAN BE FOUND AT \
YOUR OUTPUT AREA."

