#
# SHELL SCRIPT TO BUILD CTPPSFastSim IN LXPLUS
#

# PARAMETERS:
CMSSW=CMSSW_8_0_24 # or later
echo "Setting up CMSSW environment $CMSSW"
ARCH=slc6_amd64_gcc493
echo "Setting up scram arch $ARCH"

# SETUP:
AREA=$PWD
SCRAM_ARCH=$ARCH
scram project $CMSSW
echo "Setting up scram area"
cd $CMSSW/src
echo "Activating CMSSW area"
eval `scramv1 runtime -sh`
echo "Cloning CT-PPS fast simulation modules"
git clone https://github.com/CTPPS/CTPPSFastSim.git
mv CTPPSFastSim/FastSimulation/ $AREA/$CMSSW/src
rm -rf CTPPSFastSim/
mkdir -p Configuration/Generator/python
cd Configuration/Generator/python
echo "Fetching customized reader for hepMC inputs"
wget https://raw.githubusercontent.com/uerj-cms-cep-studies/tmp/master/readHepMC_cff.py
cd $AREA/$CMSSW/src
echo "Compiling CMSSW environemt"
scram b -j 8
