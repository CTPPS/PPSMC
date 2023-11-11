#!/bin/bash

# mapping arguments:
id=$1
eosroot=$2
eosarea=$3
tag=$5
# setting up environment:
export SCRAM_ARCH=slc7_amd64_gcc820
cmsrel CMSSW_10_0_5
cd CMSSW_10_0_5/src
cmsenv
#git clone git://github.com/delphes/delphes.git Delphes
mv ../../delphes-pps.tar.gz .
tar xvf delphes-pps.tar.gz
cd delphes
#cd cards
#wget https://raw.githubusercontent.com/jjhollar/DelphesNtuplizer/master/cards/CMS_PhaseII_200PU_Snowmass2021_v0_WithProtons.tcl
#wget https://raw.githubusercontent.com/jjhollar/DelphesNtuplizer/master/cards/muonMomentumResolution.tcl
#wget https://raw.githubusercontent.com/jjhollar/DelphesNtuplizer/master/cards/electronTightId_200PU_VAL.tcl
#cd ..
#rsync -avPz /eos/cms/store/group/upgrade/delphes/PhaseII/MinBias_100k.pileup ./MinBias_100k.pileup
./configure
sed -i -e 's/c++0x/c++1y/g' Makefile
make -j8
# check if EOS area ready:
if [ ! -d "${eosarea}/Delphes/PU200/${tag}_ZLepDecays_Delphes_PU200" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${eosarea}/Delphes/PU200/${tag}_ZLepDecays_Delphes_PU200
fi
# inputs:
label=${tag}_${id}
filein=${label}_GEN.root
xrdcp -f ${eosroot}/${eosarea}/GEN/${tag}/${filein} .
fileout=${label}_ZLepDecays_Delphes_PU200.root
# run:
./DelphesCMSFWLite cards/CMS_PhaseII_200PU_Snowmass2021_v0_WithProtons.tcl ${fileout} ${filein}
# transfer files to EOS:
xrdcp -f ${fileout} ${eosroot}/${eosarea}/Delphes/PU200/${tag}_ZLepDecays_Delphes_PU200/${fileout}
# clean working node:
cd ../../..
rm -rf CMSSW*
rm -rf `whoami`.cc

