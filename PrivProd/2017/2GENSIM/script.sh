#!/bin/sh
cat <<'EndOfTestFile' > local.sh
#!/bin/sh
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc6_amd64_gcc630
scram project CMSSW_9_3_13
cd CMSSW_9_3_13/src/
eval `scramv1 runtime -sh`
cp xpwd/0cfg/xcfginput ./
cp xarea/pLHE/xjob/xinput ./
scramv1 b
cmsRun xcfginput
mkdir -p xarea/GENSIM/xjob/
rsync -avPz xoutput xarea/GENSIM/xjob/xoutput
rm -rf *
EndOfTestFile
chmod +x local.sh

# Run in SLC6 container
# Mount afs, eos, cvmfs
# Mount /etc/grid-security for xrootd
singularity run -B /afs -B /eos -B /cvmfs -B /etc/grid-security --home $PWD:$PWD docker://cmssw/slc6:latest $PWD/local.sh
