#!/bin/sh
cat <<'EndOfTestFile' > local.sh
#!/bin/sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc6_amd64_gcc530
scram project CMSSW_8_0_31
cd CMSSW_8_0_31/src/
eval `scramv1 runtime -sh`
cp xpwd/0cfg/xcfginput ./
scramv1 b
cmsRun xcfginput
mkdir -p /eos/cms/store/group/phys_pps/MC/requests_2016mc/private/AAZZ_bSM/AODSIM/xjob/
rsync -avPz xoutput /eos/cms/store/group/phys_pps/MC/requests_2016mc/private/AAZZ_bSM/AODSIM/xjob/xoutput
rm -rf xoutput
EndOfTestFile
chmod +x local.sh

# Run in SLC6 container
# Mount afs, eos, cvmfs
# Mount /etc/grid-security for xrootd
singularity run -B /afs -B /eos -B /cvmfs -B /etc/grid-security --home $PWD:$PWD docker://cmssw/slc6:latest $PWD/local.sh
