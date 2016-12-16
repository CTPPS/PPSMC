#
# SHELL SCRIPT TO BUILD FPMC IN LXPLUS
#

AREA=$PWD
git clone https://github.com/ForwardPhysicsMC/fpmc.git
cd $AREA/fpmc/
source setup_lxplus.sh
make fpmc-hepmc
cd $AREA
