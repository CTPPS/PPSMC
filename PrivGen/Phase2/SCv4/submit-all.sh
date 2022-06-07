#!/bin/bash

# submit all dag files in current dir:
for i in `ls *.dag`
do
    condor_submit_dag $i
done
