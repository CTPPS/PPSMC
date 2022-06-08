#!/bin/bash

# mapping arguments:
eosroot=$1
eosarea=$2
label=$3
it=$4
evts=$5
split=$6
cmssw=$7
# setup cmssw
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc10
scram project $cmssw
cd $cmssw/src/
eval `scramv1 runtime -sh`
scram b -j8
# number events per file
nevtsperfile=$(( ${evts}/${split} ))
# run root converter
xrdcp ${eosroot}/${eosarea}/${label}/${label}.lhe.xz ./${label}.lhe.xz
xz -d ${label}.lhe.xz
cp ../../config.py .
cmsRun config.py input_file=file:''${label}'.lhe'
# split events
cp ../../writer.py .
cmsRun writer.py numevents=$nevtsperfile first_event=$(( it * nevetsperfile ))
mv writer.lhe ${label}_${it}.lhe
# check if EOS area ready:
if [ ! -d "${eosarea}/split" ]; then
    xrdfs eoscms.cern.ch mkdir -p ${eosarea}/split
fi
# compress output:
xz ${label}_${it}.lhe
if ! xz -tvv ${label}_${it}.lhe.xz &> /dev/null; then
    echo "Corrupted .lhe.xz file -- Exiting."
    exit 1
fi
# transfer files to EOS:
xrdcp -f ${label}_${it}.lhe.xz ${eosroot}/${eosarea}/${label}/split/${label}_${it}.lhe.xz
# clean working node
cd ../..
rm -rf CMSSW*
rm -rf `whoami`.cc
