#
# SHELL SCRIPT TO BUILD FPMC IN LXPLUS
#

AREA=$PWD
echo "Setting local area at: $AREA"
echo 'Cloning git repository for FPMC'
git clone https://github.com/ForwardPhysicsMC/fpmc.git
cd $AREA/fpmc/
echo 'Setting up LXPLUS interface'
source setup_lxplus.sh
echo 'Compiling...'
make fpmc-hepmc
cd $AREA
echo 'Done.'
