
# Details here: https://twiki.cern.ch/twiki/bin/view/Sandbox/PpsCepStudies#FPMC
CMSSW=CMSSW_8_0_1
AREA=$PWD/$CMSSW/src/
OUTPUTFILE=dataWW.py
INPUTFILE=dataWW.hepmc

cp fpmc/$INPUTFILE $AREA

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
	--fileout=dataWW.root \
	--python_filename=$OUTPUTFILE

# Replace input file:

sed -i -e 's/FPMC_WW_Inclusive_13TeV/dataWW/g' Configuration/Generator/python/readHepMC_cff.py

# modify the resulting driver (in this examples, 'readHepMC_cff_py_GEN_SIM_RECOBEFMIX_DIGI_RECO.py')
# by adding the following line, with 'source' as the input HepMC sample:
# process.VtxSmeared.src = 'source'

sed '94iprocess.VtxSmeared.src = "'$INPUTFILE'"' $OUTPUTFILE > test.py
mv test.py $OUTPUTFILE

# filter has to be modified to include specific channels; for WW see:
# https://raw.githubusercontent.com/uerj-cms-cep-studies/tmp/master/inputHepMC.cc
mkdir inputHepMC
cd inputHepMC
mkedfltr inputHepMC
cd ..

# when ready, run:
scram b -j 8
# and:
cmsRun dataWW.py
# or equivalent driver.
