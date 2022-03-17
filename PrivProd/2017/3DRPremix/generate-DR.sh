#!/bin/bash 

###################################################################
#Script Name : generate-DR
#Description : generate DRPremix step in CMSSW simulation chain
#Args        : work area + condor job name
#Author      : Gustavo Gil da Silveira (UFRGS|UERJ, Brazil)
###################################################################

# INPUT PARAMETERS

# Area with GS input file and storage for output files:
farea=""
# Number of events to be processed:
nevt=0
# Split in how many output files:
nfiles=0

# GRID CERTIFICATE
# Place your personal GRID certificate at /afs/cern.ch/user/<u>/<user>/private/
# with permissions set to 0600

# User GRID certificate filename, e.g., x509up_u12345: 
gridcert="x509up_u"

# SCRIPT

# Check wether user has provided the necessary parameters:
if [ $# -eq 0  ]
then
   echo ">>> ERROR: missing arguments"
   echo "Usage: ./generate-DR [files tag] [jobname]"
   echo "[files tag] will be used for the filename of the output files"
   echo "[jobname] is the condor job name to appear in the condor queue"
   exit 1
fi
# Check wether user has provided GRID certificate:
if [ -z "$gridcert" ]
then
    echo ">>> ERROR: no GRID certificate provided"
    exit 1
fi

# Confirm user parameters are good:
echo -e "\e[4mFile tag:\e[0m $1"
echo -e "\e[4mjobname:\e[0m $2"
read -p "OK? Press [enter]"

# Create local job area:
step="DRPremix"
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
   input="$1"_GENSIM_"$i".root
   cfginput="$1"_"$step"_cfg_"$i".py
   shinput="$1"_"$i".sh
   subinput="$1"_"$i".sub
   output="$1"_"$step"_"$i".root
   # Copy config template:
   cp ../config.py 0cfg/$cfginput
   # Replace strings in auxiliary files with user inputs:
   sed -i "s/xinput/$input/g" 0cfg/$cfginput
   sed -i "s/xfileout/$output/g" 0cfg/$cfginput
   # Copy script template:
   cp ../script.sh 1sh/"$1"_"$i".sh
   # Replace strings in auxiliary files with user inputs:
   sed -i "s?xarea?$farea?g" 1sh/$shinput
   sed -i "s/xcfginput/$cfginput/g" 1sh/$shinput
   sed -i "s/xoutput/$output/g" 1sh/$shinput
   sed -i "s/xinput/$input/g" 1sh/$shinput
   sed -i "s/xjob/$1/g" 1sh/$shinput
   sed -i 's?xpwd?'`pwd`'?' 1sh/$shinput
   sed -i 's?xhome?'`echo $HOME`'?' 1sh/$shinput
   sed -i "s/xcert/$gridcert/g" 1sh/$shinput
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
