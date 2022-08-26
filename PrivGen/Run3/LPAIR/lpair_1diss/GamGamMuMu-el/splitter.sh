#!/bin/bash

# setup cmssw
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc10
cmssw=$7
scram project $cmssw
cd $cmssw/src/
eval `scramv1 runtime -sh`
scram b -j8
# number events per file
nevts=$5 
split=$6
it=$4
nevtsperfile=$(( ${5}/${6} ))
# run root converter
xrdcp -s ${1}/${2}/${3}/${3}.lhe ./${3}.lhe
cp ../../config.py .
cmsRun config.py input_file=file:''${3}'.lhe'
# split events
cp ../../writer.py .
cmsRun writer.py numevents=$nevtsperfile first_event=$(( it * nevetsperfile ))
mv writer.lhe ${3}_${4}.lhe
if [ ! -d "${2}/split" ]; then
    xrdfs eoscms.cern.ch mkdir -p ${2}/split
fi
xrdcp -fs ${3}_${4}.lhe ${1}/${2}/${3}/split/${3}_${4}.lhe
# clean working node
cd ../..
rm -rf CMSSW*
