#!/bin/sh

# INPUT PARAMETERS

# LHE input files
input="FPMC_WW_bSM_13tev_a0w_5e-6_aCw_0_decayALL_pt0.lhe"
# Area with LHE input file and storage for output files
farea="/eos/cms/store/group/phys_pps/MC/misc/test-area/AAWW_bSM"
# Number of events to be processed
nevt=1000
# Split in how many output files
nfiles=1

# SCRIPT

if [ $# -eq 0  ]
then
   echo ">>> ERROR: missing arguments"
   echo "Usage: ./generate-pLHE [files tag] [jobname]"
   echo "[files tag] will be used for the filename of the output files"
   echo "[jobname] is the condor job name to appear in the condor queue"
   exit 1
fi

echo -e "\e[4mOutput area:\e[0m $farea"
echo -e "\e[4mFile tag:\e[0m $1"
echo -e "\e[4mjobname:\e[0m $2"
read -p "OK? Press [enter]"

mkdir -p $1
cd $1

mkdir -p 0cfg
mkdir -p 1sh
mkdir -p 2sub
mkdir -p 3err

localpwd=$(pwd)

block=$(( nevt/nfiles ))

end=$nfiles

for ((i=0; i<=end-1; i++));
do
   cfginput="$1"_cfg_"$i".py
   shinput="$1"_"$i".sh
   subinput="$1"_"$i".sub
   output="$1_pLHE_$i.root"
   blocks=$(( i*100+1 ))
   first=$(( i*1000+1 ))
   cp ../config.py 0cfg/$cfginput
   sed -i "s/xinput/$input/g" 0cfg/$cfginput
   sed -i "s/xevt/$block/g" 0cfg/$cfginput
   sed -i "s/xskip/$(( i*block ))/g" 0cfg/$cfginput
   sed -i "s/xfileout/$output/g" 0cfg/$cfginput
   sed -i "s/xblock/$blocks/g" 0cfg/$cfginput
   sed -i "s/xfirst/$first/g" 0cfg/$cfginput
   cp ../script.sh 1sh/"$1"_"$i".sh
   sed -i "s/xcfginput/$cfginput/g" 1sh/$shinput
   sed -i "s?xarea?$farea?g" 1sh/$shinput
   sed -i "s/xinput/$input/g" 1sh/$shinput
   sed -i "s/xoutput/$output/g" 1sh/$shinput
   sed -i "s/xjob/$1/g" 1sh/$shinput
   sed -i 's?xpwd?'`pwd`'?' 1sh/$shinput
   cp ../condor.sub 2sub/$subinput
   sed -i "s/xshinput/$shinput/g" 2sub/$subinput
   sed -i "s/xerr/$1_$i/g" 2sub/$subinput
   sed -i "s/xjobname/$2_$i/g" 2sub/$subinput
done

# Comment the line below to submit jobs
#exit 1

cd 2sub
for i in *.sub;
do
   condor_submit "$i"
done
