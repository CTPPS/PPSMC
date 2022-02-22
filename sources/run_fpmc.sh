#!/bin/sh

# Step to run HepMC output. Similar steps for LHE output below.

cd fpmc/
source setup_lxplus.sh
./fpmc-hepmc \
	--cfg Datacards/dataExcJJ_CHIDe \
	--comenergy 13000 \
	--fileout data_dijets.hepmc \
	--nevents 100

# Proper parameters should be entered/reviewed in the input card

#cd fpmc/
#source setup_lxplus.sh
#./fpmc-lhe < Datacards/dataExcJJ_CHIDe
