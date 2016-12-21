
# Details here: https://twiki.cern.ch/twiki/bin/view/Sandbox/PpsCepStudies#FPMC

# variable JOBNAME is been used for IO filenames from simulation and event sample used as input:
#
# $JOBNAME.hepmc: input event sample from FPMC
# $JOBNAME.py: config file for cmsRun
# $JOBNAME.root: output file from simulation

CMSSW=CMSSW_8_0_1
AREA=$PWD/$CMSSW/src/
JOBNAME=data_dijets
NEVENTS=100

echo "Copying event sample"
cp fpmc/$JOBNAME.hepmc $AREA

cd $AREA
echo "Setting up CMSSW environment"
eval `scramv1 runtime -sh`

echo "Creating configuration file from cmsDriver"
cmsDriver.py \
	readHepMC_cff.py \
	-n $((NEVENTS)) \
	--fast \
	--conditions auto:run2_mc \
	--eventcontent AODSIM \
	-s GEN,SIM,RECOBEFMIX,DIGI:pdigi_valid,RECO \
	--beamspot Realistic50ns13TeVCollision \
	--datatier GEN-SIM-DIGI-RECO \
	--pileup NoPileUp \
	--era Run2_25ns \
	--customise FastSimulation/PPSFastSim/customise_FastSimCTPPS_cff.customise \
	--no_exec \
	--fileout="$JOBNAME".root \
	--python_filename="$JOBNAME".py

# Replace input file:

echo "Replacing input filename for hepMC format"
sed -i 's/file:.*.hepmc/file:'"$JOBNAME"'.hepmc/g' Configuration/Generator/python/readHepMC_cff.py

# modify the resulting driver (in this examples, 'readHepMC_cff_py_GEN_SIM_RECOBEFMIX_DIGI_RECO.py')
# by adding the following line, with 'source' as the input HepMC sample:
# process.VtxSmeared.src = 'source'

echo "Adding hepMC event sample for simulation"
sed '94iprocess.VtxSmeared.src = '"\"$JOBNAME"'.hepmc\"' "$JOBNAME".py > test.py
mv test.py $JOBNAME.py

# filter has to be modified to include specific channels; for WW see:
# https://raw.githubusercontent.com/uerj-cms-cep-studies/tmp/master/inputHepMC.cc
echo "Fetching ED filter"
mkdir inputHepMC
cd inputHepMC
mkedfltr inputHepMC
cd ..

# when ready, run:
echo "Compiling CMSSW area"
scram b -j 8
# and:
echo "Running job"
cmsRun $JOBNAME.py
# or equivalent driver.
