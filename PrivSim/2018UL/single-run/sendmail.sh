#!/bin/bash

step=$1
email=`whoami`
TMPDIR=/tmp/

mail -s "step ${step} FINISHED" $email <<< "STEP \
pLHE HAS FINISHED AND FILES CAN BE FOUND AT \
YOUR OUTPUT AREA."

