#!/bin/bash

###################################################################
#Script Name : JobChecker.sh
#Description : Check for failed condor jobs and resubmit them
#Args        : work area
#Author      : Gustavo Gil da Silveira (UFRGS|UERJ, Brazil)
###################################################################

# Function to enter workdir and resubmit condor scripts:
submit() {
    echo ">>> Resubmitting jobs"
    cd ${1}/2sub
    for i in "${list[@]}"
    do
        condor_submit ${1%/}_${i}.sub
        sed -i 's/FallbackFileOpenError/RESUBMITTED/g' ${1%/}_${i}.sub
    done
    cd -
}

# Check jobs with common error:
list=($(grep -l FallbackFileOpenError ${1}/3err/* | cut -d '.' -f 1 | rev | cut -d '_' -f 1 | rev))

# Report number of failed jobs?
echo "${#list[@]} jobs failed with error FallbackFileOpenError"

# Check if user wants to resubmit failed jobs:
read -p ">>> Resubmit all failed jobs? [Yes/No]: " yn
case $yn in
    [Yy]* ) submit $1 ;;
    [Nn]* ) exit 1;;
    * ) echo "Please answer (Y)yes or (N)no.";;
esac

### END
