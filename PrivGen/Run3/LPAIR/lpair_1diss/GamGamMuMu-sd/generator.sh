#!/bin/bash

# sourcing CERN LCG 101 to compile LPAIR with latest ROOT:
source /cvmfs/sft.cern.ch/lcg/views/setupViews.sh LCG_101 x86_64-centos7-gcc8-opt
# installing mc generator:
git clone https://github.com/forthommel/lpair.git
cd lpair/desy
make
# preping input card:
label=${2}
cp ../../input.card ${label}.card
sed -i "s@xproc@$label@g" ${label}.card
sed -i "s@xid@$3@g"     ${label}.card
sed -i "s@xscatt1@$4@g" ${label}.card
sed -i "s@xscatt2@$5@g" ${label}.card
sed -i "s@xpt@$6@g"   ${label}.card
sed -i "s@xseed@$7@g" ${label}.card
sed -i "s@xevt@$8@g"  ${label}.card
# check if EOS area ready:
if [ ! -d "${1}/${2}" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${1}/${2}
fi
# folder for split files:
xrdfs eoscms.cern.ch mkdir -p ${1}/${2}
# run:
cp ${label}.card lpair.card
./lpair < lpair.card > ${label}.txt
root -q -b 'ConvertLPairToLHE.C("events.root","'${label}.lhe'",'$8',0)'
# transfer files to EOS (remove for xfer):
xrdcp -s ${label}.lhe ${9}/${1}/${2}/${label}.lhe
xrdcp -s ${label}.card ${9}/${1}/${2}/${label}.card
xrdcp -s ${label}.txt ${9}/${1}/${2}/${label}.txt
# clean workind node
cd ../..
rm -rf lpair/
