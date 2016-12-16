
# Details here: https://twiki.cern.ch/twiki/bin/view/Sandbox/PpsCepStudies#FPMC
CMSSW=CMSSW_8_0_1
AREA=$CMSSW/src/
cd $AREA
eval `scramv1 runtime -sh`

cmsDriver.py \
	readHepMC_cff.py \
	-n 10 \
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
	--filein=dataWW.hepmc \
	--fileout=dataWW.root \
	--python_filename=dataWW.py

exit

# modify the resulting driver (in this examples, 'readHepMC_cff_py_GEN_SIM_RECOBEFMIX_DIGI_RECO.py')
# by adding the following line, with 'source' as the input HepMC sample:
# process.VtxSmeared.src = 'source'

mkdir inputHepMC
cd inputHepMC
# filter has to be modified to include specific channels; for WW see:
# https://raw.githubusercontent.com/uerj-cms-cep-studies/tmp/master/inputHepMC.cc
mkedfltr inputHepMC

# when ready, run:
 scram b -j 8
# and:
cmsRun dataWW.py
# or equivalent driver.
