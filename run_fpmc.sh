
cd fpmc/
source setup_lxplus.sh
./fpmc-hepmc \
	--cfg Datacards/dataDPE_Dijets \
	--comenergy 13000 \
	--fileout data_dijets.hepmc \
	--nevents 100
