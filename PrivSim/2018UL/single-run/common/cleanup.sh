#!/bin/bash

eosarea=$1
prodname=$2
cmssw=$3
scram=$4

# FIRST TEST THE MINI OUTPUTS:
export HOME=/tmp # https://github.com/cms-sw/cmssw/issues/33466
export EOS_MGM_URL=root://eoscms.cern.ch
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=${scram}
scram project ${cmssw}
cd ${cmssw}/src/
eval `scramv1 runtime -sh`
scramv1 b -j8

file_error=0
for i in `ls ${eosarea}/${prodname}/MINI/`;
do
    root -l -b -q -e 'bool is_zombie = TFile("'${eosarea}/${prodname}/MINI/${i}'").IsZombie(); return is_zombie ? 1 : 0'
    if [ $? -eq 1 ]; then echo "Problem found in file ${i}" && $file_error=1; else echo "File ${i} OK"; fi
done

if [ $file_error -eq 1 ];
then
    echo ">>> At least one MINI output with error"
    exit 1
fi

# CLEAN INTERMEDIATE STEPS:
echo "Cleaning pLHE step"
rm -rf ${eosarea}/${prodname}/pLHE/* && echo "Done" || echo "ERROR"
echo "Cleaning GEN step"
rm -rf ${eosarea}/${prodname}/GEN/* && echo "Done" || echo "ERROR"
echo "Cleaning SIM step"
rm -rf ${eosarea}/${prodname}/SIM/* && echo "Done" || echo "ERROR"
echo "Cleaning DR step"
rm -rf ${eosarea}/${prodname}/DRPremix/* && echo "Done" || echo "ERROR"
echo "Cleaning HLT step"
rm -rf ${eosarea}/${prodname}/HLT/* && echo "Done" || echo "ERROR"
echo "Cleaning RECO step"
rm -rf ${eosarea}/${prodname}/RECO/* && echo "Done" || echo "ERROR"

# CLEAN REMOTE MACHINE:
rm -rf CMSSW*
rm -rf $( whoami ).cc

# BYE:
echo ">>> Cleaning complete"

