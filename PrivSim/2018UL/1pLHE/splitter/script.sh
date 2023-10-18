#!/bin/bash

# collecting input arguments:
id=$1
inputlhe=$2
evts=$3
nfiles=$4
block=$5
scram=$6
cmssw=$7
eosarea=$8

# job definitions:
inputfile=$(basename $inputlhe)
step=pLHE
stageout=root://eoscms.cern.ch/${eosarea}/${step}
if [ ! -d ${stageout} ]
then
    xrdfs eoscms.cern.ch mkdir ${stageout}
fi
noext=$(basename $inputlhe .lhe)
output=${noext}_pLHE.root

# prep config files:
first=$(( i*$block+1 ))
skip=$(( id*block ))
cp ../../config.py .
sed -i "s@xinput@$inputfile@g" config.py
sed -i "s@xevt@$block@g" config.py
sed -i "s@xskip@$skip@g" config.py
sed -i "s@xfileout@$output@g" config.py
sed -i "s@xblock@$blocks@g" config.py
sed -i "s@xfirst@$first@g" config.py

# write header to local file:
cat <<EOF > local.sh
#!/bin/bash
export EOS_MGM_URL=root://eoscms.cern.ch
source /cvmfs/cms.cern.ch/cmsset_default.sh
EOF

# now do the details from user input:
echo "export SCRAM_ARCH=${scram}" >> local.sh
echo "scram project CMSSW_10_6_21" >> local.sh
echo "cd CMSSW_10_6_21/src/" >> local.sh
echo "eval `scramv1 runtime -sh`" >> local.sh
echo "scramv1 b" >> local.sh
echo "xrdcp -fs ${inputlhe} ." >> local.sh
echo "cmsRun config.py" >> local.sh
echo "xrdcp -fs $output ${stageout}/${output}" >> local.sh
echo "cd ../.." >> local.sh
echo "rm -rf CMSSW/" >> local.sh
echo "rm -rf $(whoami).cc" >> local.sh

# make local file executable:
chmod +x local.sh

# Run in SLC6 container
# Mount afs, eos, cvmfs
# Mount /etc/grid-security for xrootd
singularity run -B /afs -B /eos -B /cvmfs -B /etc/grid-security --home $PWD:$PWD docker://cmssw/slc6:latest $PWD/local.sh
