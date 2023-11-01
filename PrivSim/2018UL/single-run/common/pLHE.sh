#!/bin/bash

# collecting input arguments:
id=$1
inputpath=$2
scram=$3
cmssw=$4
eosarea=$5
jobname=$6
config=$7

# job definitions:
step=pLHE
stagein=${inputpath}/${jobname}/LHE/split
stageout=${eosarea}/${jobname}/${step}
if [ ! -d ${stageout} ]
then
    mkdir ${stageout}
fi
inputfile=${jobname}_${id}.lhe
xrdcp -fs ${stagein}/${inputfile}.xz .
xz -v -d ${inputfile}.xz
output=${jobname}_${id}_${step}.root

# start:
export EOS_MGM_URL=root://eoscms.cern.ch
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=${scram}
scram project ${cmssw}
cd ${cmssw}/src/
curl -s -k https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/PPS-RunIISummer20UL18pLHEGEN-00004 --retry 3 --create-dirs -o Configuration/GenProduction/python/PPS-RunIISummer20UL18pLHEGEN-00004-fragment.py
eval `scramv1 runtime -sh`
scramv1 b -j8

# prep config files:
mv ../../${inputfile} .
mv ../../$config .
sed -i "s@xinput@$inputfile@g" $config
sed -i "s@xfileout@$output@g" $config

# run:
cmsRun $config

# move output:
xrdcp -fs $output ${stageout}/${output}
cd ../..

# clean area:
rm -rf CMSSW*
rm -rf $(whoami).cc
