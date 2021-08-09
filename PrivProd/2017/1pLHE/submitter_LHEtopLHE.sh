#!/bin/sh

if [ $# -eq 0  ]
then
   echo "Missing arguments; usage ./submitterLHEtopLHE [files tag] [jobname]"
   echo "Usage: ./submitterLHEtopLHE [files tag] [jobname]"
   exit 1
fi

echo -e "\e[4mFile tag:\e[0m $1"
echo -e "\e[4mjobname:\e[0m $2"
read -p "OK? Press [enter]"

mkdir -p $1
cd $1

mkdir -p 0cfg
mkdir -p 1sh
mkdir -p 2sub
mkdir -p 3err
mkdir -p 3out
mkdir -p 4log

nevt=100000
nfiles=1
input="$1.lhe"

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
   sed -i "s/xoutput/$output/g" 1sh/$shinput
   sed -i "s/xjob/$1/g" 1sh/$shinput
   sed -i 's?xpwd?'`pwd`'?' 1sh/$shinput
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
