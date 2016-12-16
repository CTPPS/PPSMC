
cd fpmc/
source setup_lxplus.sh
./fpmc-hepmc \
	--cfg Datacards/dataQED_WW \
	--comenergy 13000 \
	--fileout dataWW.hepmc \
	--nevents 10
