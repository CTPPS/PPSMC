#!/bin/bash

# mapping arguments:
$(EOSROOT) $(EOSAREA) $(PROCLABEL) $(A0W) $(ACW) $(EVTS) $(ProcId)
eosroot=$1
eosarea=$2
tag=$3
a0w=$4
aCw=$5
evts=$6
it=$7
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
sed -i "s@xevt@$evts@g" ${label}.card
sed -i "s@xrand1@$RANDOM@g" ${label}.card
sed -i "s@xrand2@$RANDOM@g" ${label}.card
sed -i "s@xa0w@$a0w@g" ${label}.card
sed -i "s@xacw@$aCw@g" ${label}.card
if [ "${a0w}" != "0E0" ] || [ "${aCw}" != "0E0" ];
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
# transfer files to EOS
xrdcp -fs ${label}.lhe ${eosroot}/${eosarea}/${tag}/split/${label}.lhe
xrdcp -fs ${label}.txt ${eosroot}/${eosarea}/${tag}/split/${label}.txt
xrdcp -fs ${label}.card ${eosroot}/${eosarea}/${tag}/split/${label}.card
# clean working node
cd ../..
rm -rf fpmc/
