#!/bin/bash
cat <<'EndOfTestFile' > local.sh
#!/bin/bash
export EOS_MGM_URL=root://eoscms.cern.ch
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc6_amd64_gcc630
scram project CMSSW_9_4_7
cd CMSSW_9_4_7/src/
eval `scramv1 runtime -sh`
xrdcp -s xpwd/0cfg/xcfginput ./xcfginput
xrdcp -s xeos/xarea/DRPremix/xjob/xinput ./xinput
scramv1 b
cmsRun xcfginput
xrdfs eoscms.cern.ch mkdir -p xarea/AODSIM/xjob/
xrdcp -f -s xoutput xeos/xarea/AODSIM/xjob/xoutput
rm -rf *
EndOfTestFile
chmod +x local.sh

# Run in SLC6 container
# Mount afs, eos, cvmfs
# Mount /etc/grid-security for xrootd
singularity run -B /afs -B /eos -B /cvmfs -B /etc/grid-security --home $PWD:$PWD docker://cmssw/slc6:latest $PWD/local.sh
