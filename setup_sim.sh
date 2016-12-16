#
# SHELL SCRIPT TO BUILD CTPPSFastSim IN LXPLUS
#

# PARAMETERS:
CMSSW=CMSSW_8_0_1 # or later
ARCH=slc6_amd64_gcc493

# SETUP:
AREA=$PWD
SCRAM_ARCH=$ARCH
scram project $CMSSW
cd $CMSSW/src
eval `scramv1 runtime -sh`
git clone https://github.com/CTPPS/CTPPSFastSim.git
mv CTPPSFastSim/FastSimulation/ $AREA/$CMSSW/src
rm -rf CTPPSFastSim/
mkdir -p Configuration/Generator/python
cd Configuration/Generator/python
wget https://raw.githubusercontent.com/uerj-cms-cep-studies/tmp/master/readHepMC_cff.py
cd $AREA/$CMSSW/src
scram b -j 8
