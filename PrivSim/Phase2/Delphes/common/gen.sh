#!/bin/bash

# mapping arguments:
id=$1
eosroot=$2
eosarea=$3
vCMSSW=$4
tag=$5
# setting up environment:
cmsrel $vCMSSW
cd $vCMSSW/src
cmsenv
cp ../../config* .
# run GEN step:
label=${tag}_${id}
filein=${label}.lhe.xz
xrdcp -fs ${eosroot}/${eosarea}/LHE/EFT/AAWW/${tag}/split/${filein} ./${filein}
xz -d $filein
filein=${label}.lhe
fileout=${label}_GEN_noDecay.root
sed -i "s/xfilein/${filein}/g" config_gen.py
sed -i "s/xfileout/${fileout}/g" config_gen.py
cmsRun config_gen.py
# check if EOS area ready:
if [ ! -d "${eosarea}/GEN/${tag}_GEN" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${eosarea}/GEN/${tag}_GEN
fi
# run GEN decays:
filein=$fileout
fileout=${label}_GEN.root
sed -i "s/xfilein/${filein}/g" config_decay.py
sed -i "s/xfileout/${fileout}/g" config_decay.py
cmsRun config_decay.py
# transfer files to EOS:
xrdcp -f ${fileout} ${eosroot}/${eosarea}/GEN/${tag}/${fileout}
# clean working node:
cd ../../
rm -rf CMSSW*
rm -rf `whoami`.cc

