#!/bin/bash

#setting up environment:
. /cvmfs/sft.cern.ch/lcg/contrib/gcc/8/x86_64-centos7-gcc8-opt/setup.sh
# installing mc generator:
git clone https://github.com/fpmc-hep/fpmc.git
cd fpmc
sed -i "s@\^lxplus\[0-9\]+@@g" cmake/UseEnvironment.cmake
mkdir build && cd build
cmake3 ..
make -j8 fpmc-lhe
cd ../..
# preping input card:
cp input.card ${2}.card 
sed -i "s@xlabel@$2@g" ${2}.card
sed -i "s@xa0w@$3@g"   ${2}.card
sed -i "s@xacw@$4@g"   ${2}.card
if [ "$3" != "0E0" ] || [ "$4" != "0E0" ];
then
    sed -i "s@xanom@2@g" ${2}.card
else
    sed -i "s@xanom@0@g" ${2}.card
fi
# check if EOS area ready:
if [ ! -d "${1}/${2}" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${1}/${2}
fi
# run:
./fpmc/build/fpmc-lhe < ${2}.card > ${2}.txt
