#!/bin/bash

# setup cmssw
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc10
cmssw=$2
scram project $cmssw
cd $cmssw/src/
eval `scramv1 runtime -sh`
scram b -j8
# copy inputs
ppseos=$3
xrdcp -s root://eoscms.cern.ch/${ppseos}/${1}/${1}.lhe ./${1}.lhe
# run
cp ../../config.py .
sed -i "s@xinput@${1}.lhe@g" config.py
cmsRun config.py 1> ${1}_MCDBToEDM.txt 2>&1
#transfer outputs
xrdcp -fs ${1}_MCDBToEDM.txt root://eoscms.cern.ch/${ppseos}/${1}/${1}_MCDBToEDM.txt
# clean working node
cd ../..
rm -rf CMSSW*
