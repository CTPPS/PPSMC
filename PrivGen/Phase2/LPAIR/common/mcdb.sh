#!/bin/bash

# mapping arguments:
label=$1
cmssw=$2
eosarea=$3
eosroot=$4
# setup cmssw:
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc10
scram project $cmssw
cd $cmssw/src/
eval `scramv1 runtime -sh`
scram b -j8
# copy inputs:
xrdcp ${eosroot}/${eosarea}/${label}/${label}.lhe.xz ./${label}.lhe.xz
# run:
cp ../../mcdb.py .
sed -i "s@xinput@${label}.lhe.xz@g" mcdb.py
cmsRun mcdb.py 1> ${label}_MCDBToEDM.txt 2>&1
# transfer outputs:
xrdcp -f ${label}_MCDBToEDM.txt ${eosroot}/${eosarea}/${label}/${label}_MCDBToEDM.txt
# clean working node:
cd ../..
rm -rf CMSSW*
rm -rf `whoami`.cc
