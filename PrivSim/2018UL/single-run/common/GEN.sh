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
step=GEN
stagein=${inputpath}/${jobname}/pLHE
stageout=${eosarea}/${jobname}/${step}
if [ ! -d ${stageout} ]
then
    mkdir ${stageout}
fi
inputfile=${jobname}_${id}_pLHE.root
output=${jobname}_${id}_${step}.root
xrdcp -fs ${stagein}/${inputfile} .

# prep config files:
sed -i "s@xinput@$inputfile@g" $config
sed -i "s@xfileout@$output@g" $config

# start:
export EOS_MGM_URL=root://eoscms.cern.ch
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=$scram
scram project $cmssw
cd ${cmssw}/src/
curl -s -k https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/PPS-RunIISummer20UL18pLHEGEN-00004 --retry 3 --create-dirs -o Configuration/GenProduction/python/PPS-RunIISummer20UL18pLHEGEN-00004-fragment.py
eval `scramv1 runtime -sh`
scramv1 b -j8
mv ../../$inputfile .
mv ../../$config .
cmsRun $config
xrdcp -fs $output ${stageout}/${output}
cd ../..

# clean area:
rm -rf CMSSW*
rm -rf $(whoami).cc
