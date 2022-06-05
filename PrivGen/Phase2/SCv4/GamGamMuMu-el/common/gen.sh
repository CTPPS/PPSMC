#!/bin/bash

# setting up environment:
source /cvmfs/sft.cern.ch/lcg/views/setupViews.sh LCG_101 x86_64-centos7-gcc8-opt
export PYTHONPATH=$PYTHONPATH:/cvmfs/sft.cern.ch/lcg/releases/Geant4/10.07.p02-1cac8/x86_64-centos7-gcc8-opt/lib64/python3.9/site-packages/
export LHAPDF_DATA_PATH=/cvmfs/sft.cern.ch/lcg/releases/MCGenerators/lhapdf/6.3.0-5d46a/x86_64-centos7-gcc9-opt/share/LHAPDF:/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current/
export PATH=$PATH:/afs/cern.ch/user/s/silveira/work/Pheno/tmdlib-install/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/afs/cern.ch/user/s/silveira/work/Pheno/tmdlib-install/lib
# installing mc generator:
wget https://superchic.hepforge.org/superchic4.13.tar.gz
tar zxfv superchic4.13.tar.gz
cd superchic4.13
make
cd bin
# mapping arguments:
it=$1
evts=$2
proc=$3
pt=$4
ppseos=$5
eosroot=$6
coll=$7
pid=$8
# preping input card:
label=${proc}_${it}
cp ../../input.card ${label}.card
sed -i "s@xseed@$it@g" ${label}.card
sed -i "s@xlabel@$label@g" ${label}.card
sed -i "s@xevt@$evts@g" ${label}.card
sed -i "s@xpt@$pt@g" ${label}.card
sed -i "s@xscatt@$coll@g" ${label}.card
sed -i "s@xpid@$pid@g" ${label}.card
# prep grids:
mkdir PDFset
cd PDFset
wget https://superchic.hepforge.org/SF_MSHT20qed_nnlo.tar.gz
tar zxfv SF_MSHT20qed_nnlo.tar.gz
export LHAPDF_DATA_PATH=$LHAPDF_DATA_PATH:$(pwd)
cd ..
./init < ${label}.card
# check if EOS area ready:
if [ ! -d "${ppseos}/${proc}" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${ppseos}/${proc}
fi
# folders for split and single files:
xrdfs eoscms.cern.ch mkdir -p ${ppseos}/${proc}/split
# run
./superchic < ${label}.card > ${label}.txt
# deal with output
mv evrecs/evrec${label}.dat ${label}.lhe
# if xz file corrupted, exits to force condor to re-run:
xz ${label}.lhe
if ! xz -tvv ${label}.lhe.xz &> /dev/null; then
    echo "Corrupted .lhe.xz file -- Exiting."
    exit 1
fi
# remove these lines to use xfer:
xrdcp -f ${label}.lhe.xz  ${eosroot}/${ppseos}/${proc}/split/${label}.lhe.xz
xrdcp -f ${label}.txt  ${eosroot}/${ppseos}/${proc}/split/${label}.txt
xrdcp -f ${label}.card ${eosroot}/${ppseos}/${proc}/split/${label}.card
# clean working node
cd ../..
rm -rf superchic* 
rm -rf `whoami`.cc
