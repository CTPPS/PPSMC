#!/bin/bash 

###################################################################
#Script Name : generate-AOD
#Description : generate AOD step in CMSSW simulation chain
#Args        : work area + codor job name
#Author      : Gustavo Gil da Silveira (UFRGS|UERJ, Brazil)
###################################################################

# INPUT PARAMETERS

# Area with pLHE input file and storage for output files:
farea="/eos/cms/store/group/phys_pps/MC/misc/test-area/AAWW_bSM/2016"
# Number of events to be processed per file:
nevt=1000
# Split in how many output files:
nfiles=10

# SCRIPT

# Check wether user has provided the necessary parameters:
if [ $# -eq 0  ]
then
   echo ">>> ERROR: missing arguments"
   echo "Usage: ./generate-AOD [files tag] [jobname]"
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
step=AODSIM
mkdir -p $1
cd $1
mkdir -p 0cfg
mkdir -p 1sh
mkdir -p 2sub
mkdir -p 3err

# Split the process in individual files:
for ((i=0; i<=$nfiles-1; i++));
do
   # Define the auxiliary files:
   input="$1"_DRPremix_"$i".root
   cfginput="$1"_"$step"_cfg_"$i".py
   shinput="$1"_"$i".sh
   subinput="$1"_"$i".sub
   output="$1"_"$step"_"$i".root
   # Set first events per file:
   cp ../config.py 0cfg/$cfginput
   # Replace strings in auxiliary files with user inputs:
   sed -i "s/xinput/$input/g" 0cfg/$cfginput
   sed -i "s/xfileout/$output/g" 0cfg/$cfginput
   # Copy script template:
   cp ../script.sh 1sh/"$1"_"$i".sh
   # Replace strings in auxiliary files with user inputs:
   sed -i "s?xarea?$farea?g" 1sh/$shinput
   sed -i "s/xcfginput/$cfginput/g" 1sh/$shinput
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
