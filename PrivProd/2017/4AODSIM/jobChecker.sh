#!/bin/bash

###################################################################
#Script Name : jobChecker.sh
#Description : Check for failed condor jobs and resubmit them
#Args        : Processing area
#Author      : Gustavo Gil da Silveira (UFRGS|UERJ, Brazil)
###################################################################

# Import user input parameters:
. ../../input

# Check wether user has provided the necessary parameters:
if [ $# -eq 0  ]
then
   echo ">>> ERROR: missing arguments"
   echo "Usage: ./jobChecker.sh [processing area]"
   exit 1
fi

# Function to enter workdir and resubmit condor scripts:
submit() {
    echo ">>> Resubmitting jobs"
    cd ${1}/2sub
    for i in "${list[@]}"
    do
        # Submit condor job:
        condor_submit ${1%/}_${i}.sub
        # Replace error by tag:
        sed -i 's/FallbackFileOpenError/RESUBMITTED/g' ../3err/${1%/}_${i}*
        sed -i 's/FileReadError/RESUBMITTED/g' ../3err/${1%/}_${i}*
        sed -i 's/A fatal system signal/RESUBMITTED/g' ../3err/${1%/}_${i}*
    done
}

# Check jobs with common error:
failOpen=($(grep -l FallbackFileOpenError ${1}/3err/* | cut -d '.' -f 1 | rev | cut -d '_' -f 1 | rev))
failRead=($(grep -l FileReadError         ${1}/3err/* | cut -d '.' -f 1 | rev | cut -d '_' -f 1 | rev))
failFatal=($(grep -l "A fatal system signal" ${1}/3err/* | cut -d '.' -f 1 | rev | cut -d '_' -f 1 | rev))

# Check storage area for missing files:
year=$(cd .. && basename $(pwd))
current=$(basename $(pwd))
echo "Checking $farea/$year/${current:1}/${1}"
files=($(ls $farea/$year/${current:1}/${1} | cut -d '.' -f 1 | rev | cut -d '_' -f 1 | rev))
jobs=($(seq 0 $(($nfiles - 1)) ))
declare -A map
for key in "${!files[@]}"; do map[${files[$key]}]="$key"; done
miss=()
for i in ${jobs[@]};
do
    [[ -n "${map[$i]}" ]] || miss+=($i)
done

# Report number of jobs that fail or with missing output files:
echo "${#failOpen[@]} jobs failed with error FallbackFileOpenError"
echo "${#failRead[@]} jobs failed with error FileReadError"
echo "${#failFatal[@]} jobs failed with error fatal signal"
echo "${#miss[@]} jobs with missing output files"

# Merge both lists into one:
sum=("${failOpen[@]}" "${failRead[@]}" "${failFatal[@]}" "${miss[@]}")
declare -A merge
for i in "${sum[@]}"; do merge["$i"]=1; done
list=("${!merge[@]}")

# Check if user wants to resubmit failed jobs:
if [[ ${#list[@]} != 0 ]];
then
    read -p ">>> Resubmit all failed jobs? [Yes/No]: " yn
    case $yn in
        [Yy]* ) submit $1 ;;
        [Nn]* ) exit 1;;
        * ) echo "Please answer (Y)yes or (N)no.";;
    esac
else
    echo "No missing jobs."
fi

### END
