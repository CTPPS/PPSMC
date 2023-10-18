#!/bin/bash

step=$1
job=$2
email=`whoami`

mail -s "${job} :: step ${step} FINISHED" $email <<< "STEP \
pLHE HAS FINISHED AND FILES CAN BE FOUND AT \
YOUR OUTPUT AREA."

