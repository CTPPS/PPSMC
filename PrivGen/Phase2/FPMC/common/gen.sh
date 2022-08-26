#!/bin/bash

# mapping arguments:
eosroot=$1
eosarea=$2
tag=$3
a0w=$4
aCw=$5
a1=$6
a2=$7
evts=$8
it=$9
pid=${10}
# setting up environment:
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
label=${tag}_${it}
cp ../../input.card ${label}.card 
sed -i "s@xlabel@$label@g" ${label}.card
sed -i "s@xid@$pid@g" ${label}.card
sed -i "s@xevt@$evts@g" ${label}.card
sed -i "s@xrand1@$RANDOM@g" ${label}.card
sed -i "s@xrand2@$RANDOM@g" ${label}.card
sed -i "s@xa0w@$a0w@g" ${label}.card
sed -i "s@xacw@$aCw@g" ${label}.card
sed -i "s@xa1@$a1@g" ${label}.card
sed -i "s@xa2@$a2@g" ${label}.card
if [ "${a0w}" != "0E0" ] || [ "${aCw}" != "0E0" ] || [ "${a1}" != "0E0" ] || [ "${a2}" != "0E0" ];
then
    sed -i "s@xanom@2@g" ${label}.card
else
    sed -i "s@xanom@0@g" ${label}.card
fi
# check if EOS area ready:
if [ ! -d "${eosarea}/${tag}/split" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${eosarea}/${tag}/split
fi
# run:
./fpmc-lhe < ${label}.card > ${label}.txt
# compress output:
xz ${label}.lhe
if ! xz -tvv ${label}.lhe.xz &> /dev/null; then
    echo "Corrupted .lhe.xz file -- Exiting."
    exit 1
fi
# transfer files to EOS:
xrdcp -f ${label}.lhe.xz ${eosroot}/${eosarea}/${tag}/split/${label}.lhe.xz
xrdcp -f ${label}.txt ${eosroot}/${eosarea}/${tag}/split/${label}.txt
xrdcp -f ${label}.card ${eosroot}/${eosarea}/${tag}/split/${label}.card
# clean working node:
cd ../..
rm -rf fpmc/
rm -rf `whoami`.cc
