#!/bin/bash

#setting up environment:
. /cvmfs/sft.cern.ch/lcg/contrib/gcc/8/x86_64-centos7-gcc8-opt/setup.sh
# installing mc generator:
git clone https://github.com/fpmc-hep/fpmc.git
cd fpmc
sed -i "s@\^lxplus\[0-9\]+@@g" cmake/UseEnvironment.cmake
mkdir build
cd build
cmake3 ..
make -j8 fpmc-lhe
# preping input card:
label=${2}_${6}
cp ../../input.card ${label}.card 
sed -i "s@xlabel@$label@g" ${label}.card
sed -i "s@xevt@$5@g" ${label}.card
sed -i "s@xrand1@$RANDOM@g" ${label}.card
sed -i "s@xrand2@$RANDOM@g" ${label}.card
sed -i "s@xa0w@$3@g" ${label}.card
sed -i "s@xacw@$4@g" ${label}.card
if [ "$3" != "0E0" ] || [ "$4" != "0E0" ];
then
    sed -i "s@xanom@2@g" ${label}.card
else
    sed -i "s@xanom@0@g" ${label}.card
fi
# check if EOS area ready:
if [ ! -d "${1}/${2}/split" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${1}/${2}/split
fi
# run:
./fpmc-lhe < ${label}.card > ${label}.txt
cp ${label}.card ../..
cp ${label}.txt ../..
cp ${label}.lhe ../..
