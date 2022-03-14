#!/bin/sh

if [ $# -eq 0  ]
then
   echo "Missing arguments; usage ./submitterpLHEtoGENSIM [files tag] [jobname]"
   echo "Usage: ./submitterpLHEtoGENSIM [files tag] [jobname]"
   exit 1
fi

echo -e "\e[4mFile tag:\e[0m $1"
echo -e "\e[4mjobname:\e[0m $2"
read -p "OK? Press [enter]"

step=DRPremix
mkdir -p $1
cd $1

mkdir -p 0cfg
mkdir -p 1sh
mkdir -p 2sub
mkdir -p 3err
mkdir -p 3out
mkdir -p 4log

cert=$(cd ~/private/ && ls x*)
nfiles=100

for ((i=0; i<=nfiles-1; i++));
do
   input="$1"_GENSIM_"$i".root
   cfginput="$1"_"$step"_cfg_"$i".py
   shinput="$1"_"$i".sh
   subinput="$1"_"$i".sub
   output="$1"_"$step"_"$i".root
   cp ../config.py 0cfg/$cfginput
   sed -i "s/xinput/$input/g" 0cfg/$cfginput
   sed -i "s/xjob/$1/g" 0cfg/$cfginput
   sed -i "s/xfileout/$output/g" 0cfg/$cfginput
   cp ../script.sh 1sh/"$1"_"$i".sh
   sed -i "s/xcfginput/$cfginput/g" 1sh/$shinput
   sed -i "s/xoutput/$output/g" 1sh/$shinput
   sed -i "s/xjob/$1/g" 1sh/$shinput
   sed -i 's?xpwd?'`pwd`'?' 1sh/$shinput
   sed -i 's?xhome?'`echo $HOME`'?' 1sh/$shinput
   sed -i "s/xcert/$cert/g" 1sh/$shinput
   cp ../condor.sub 2sub/$subinput
   sed -i "s/xshinput/$shinput/g" 2sub/$subinput
   sed -i "s/xerr/$1_$i/g" 2sub/$subinput
   sed -i "s/xjobname/$2_$i/g" 2sub/$subinput
done

exit 1

cd 2sub
for i in *.sub;
do
   condor_submit "$i"
done
