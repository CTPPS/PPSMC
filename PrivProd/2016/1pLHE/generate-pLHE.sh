#!/bin/bash 

###################################################################
#Script Name : generate-pLHE
#Description : generate pLHE step in CMSSW simulation chain
#Args        : work area + condor job name
#Author      : Gustavo Gil da Silveira (UFRGS|UERJ, Brazil)
###################################################################

# INPUT PARAMETERS

# Area with LHE input file and storage for output files
farea=""
# Number of events to be processed
nevt=0
# Split in how many output files
nfiles=0

# SCRIPT

# Check wether user has provided the necessary parameters:
if [ $# -eq 0  ]
then
   echo ">>> ERROR: missing arguments"
   echo "Usage: ./generate-pLHE [files tag] [jobname]"
   echo "[files tag] will be used for the filename of the output files"
   echo "[jobname] is the condor job name to appear in the condor queue"
   exit 1
fi

# Confirm user parameters are good:
echo -e "\e[4mOutput area:\e[0m $farea"
echo -e "\e[4mFile tag:\e[0m $1"
echo -e "\e[4mjobname:\e[0m $2"
read -p "OK? Press [enter]"

# Create local job area:
step="pLHE"
mkdir -p $1
cd $1
mkdir -p 0cfg
mkdir -p 1sh
mkdir -p 2sub
mkdir -p 3err

# Define event block size:
block=$(( nevt/nfiles ))

# Split the process in individual files:
for ((i=0; i<=$nfiles-1; i++));
do
   # Define the auxiliary files:
   input="$1".lhe
   cfginput="$1"_cfg_"$i".py
   shinput="$1"_"$i".sh
   subinput="$1"_"$i".sub
   output="$1_"${step}"_$i.root"
   # Set blocks and first events per file:
   blocks=$(( i*$nfiles+1 ))
   first=$(( i*$block+1 ))
   # Copy config template:
   cp ../config.py 0cfg/$cfginput
   # Replace strings in auxiliary files with user inputs:
   sed -i "s/xinput/$input/g" 0cfg/$cfginput
   sed -i "s/xevt/$block/g" 0cfg/$cfginput
   sed -i "s/xskip/$(( i*block ))/g" 0cfg/$cfginput
   sed -i "s/xfileout/$output/g" 0cfg/$cfginput
   sed -i "s/xblock/$blocks/g" 0cfg/$cfginput
   sed -i "s/xfirst/$first/g" 0cfg/$cfginput
   # Copy script template:
   cp ../script.sh 1sh/"$1"_"$i".sh
   # Replace strings in auxiliary files with user inputs:
   sed -i "s/xcfginput/$cfginput/g" 1sh/$shinput
   sed -i "s?xarea?$farea?g" 1sh/$shinput
   sed -i "s/xinput/$input/g" 1sh/$shinput
   sed -i "s/xoutput/$output/g" 1sh/$shinput
   sed -i "s/xjob/$1/g" 1sh/$shinput
   sed -i 's?xpwd?'`pwd`'?' 1sh/$shinput
   sed -i 's?xeos?root://eoscms.cern.ch?' 1sh/$shinput
   # Copy condor template:
   cp ../condor.sub 2sub/$subinput
   # Replace strings in auxiliary files with user inputs:
   sed -i "s/xshinput/$shinput/g" 2sub/$subinput
   sed -i "s/xerr/$1_$i/g" 2sub/$subinput
   sed -i "s/xjobname/$2_$i/g" 2sub/$subinput
done

# Comment the line below to submit jobs
#exit 1

# Access condor jobs folder:
cd 2sub
# Submit job files:
for i in *.sub;
do
   condor_submit "$i"
done

### END