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
# preping input card:
#1 ProcId
#2 evts
#3 PROCLABEL
label=${3}_${1}
mv ../../input.card ${label}.card
sed -i "s@xseed@$1@g" ${label}.card
sed -i "s@xix@$1@g" ${label}.card
sed -i "s@xlabel@$label@g" ${label}.card
sed -i "s@xevt@$2@g" ${label}.card
# prep grids:
mkdir PDFset
cd PDFset
wget https://superchic.hepforge.org/SF_MSHT20qed_nnlo.tar.gz
tar zxfv SF_MSHT20qed_nnlo.tar.gz
export LHAPDF_DATA_PATH=$LHAPDF_DATA_PATH:$(pwd)
cd ..
./init < ${label}.card
# check if EOS area ready:
ppseos=/eos/cms/store/group/phys_pps/MC/requests_2022run3
if [ ! -d "${ppseos}/${3}" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${ppseos}/${3}
fi
# folders for split and single files:
xrdfs eoscms.cern.ch mkdir -p ${ppseos}/${3}/split
# run
./superchic < ${label}.card > ${label}.txt
mv evrecs/evrec${label}.dat ${label}.lhe
# remove these lines to use xfer:
xrdcp -s ${label}.lhe root://eoscms.cern.ch/${ppseos}/$3/split/${label}.lhe
xrdcp -s ${label}.txt root://eoscms.cern.ch/${ppseos}/$3/split/${label}.txt
xrdcp -s ${label}.card root://eoscms.cern.ch/${ppseos}/$3/split/${label}.card
# clean working node
cd ../../
rm -rf superchic4.13* 
