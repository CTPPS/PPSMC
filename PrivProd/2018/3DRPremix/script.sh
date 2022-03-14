#!/bin/sh
cat <<'EndOfTestFile' > local.sh
#!/bin/sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
export X509_USER_PROXY=xhome/private/xcert
voms-proxy-info -all
voms-proxy-info -all -file xhome/private/xcert
export SCRAM_ARCH=slc6_amd64_gcc700
scram project CMSSW_10_2_5
cd CMSSW_10_2_5/src/
eval `scramv1 runtime -sh`
cp xpwd/0cfg/xcfginput ./
cp xarea/GENSIM/xinput ./
scramv1 b
cmsRun xcfginput
mkdir -p xarea/DRPremix/xjob/
rsync -avPz xoutput xarea/DRPremix/xjob/xoutput
rm -rf *
EndOfTestFile
chmod +x local.sh

# Run in SLC6 container
# Mount afs, eos, cvmfs
# Mount /etc/grid-security for xrootd
singularity run -B /afs -B /eos -B /cvmfs -B /etc/grid-security --home $PWD:$PWD docker://cmssw/slc6:latest $PWD/local.sh
