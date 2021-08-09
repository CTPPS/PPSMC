#
# SHELL SCRIPT TO BUILD FPMC IN LXPLUS
#

AREA=$PWD
echo "Setting local area at: $AREA"
echo 'Cloning git repository for FPMC'
git clone https://github.com/fpmc-hep/fpmc.git
cd $AREA/fpmc/
echo 'Setting up LXPLUS interface'
source setup_lxplus.sh
echo 'Setting up build dir'
mkdir build
cd build
echo 'Running cmake setup'
cmake3 ..
echo 'Compiling...'
make -j8
cd $AREA
echo 'Done.'
