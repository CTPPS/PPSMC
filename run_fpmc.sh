
cd fpmc/
source setup_lxplus.sh
./fpmc-hepmc \
	--cfg Datacards/dataExcJJ_CHIDe \
	--comenergy 13000 \
	--fileout data_dijets.hepmc \
	--nevents 100
