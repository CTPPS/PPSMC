#!/bin/bash

source /cvmfs/sft.cern.ch/lcg/views/setupViews.sh LCG_101 x86_64-centos7-gcc8-opt
# installing mc generator:
svn checkout https://github.com/diemort/PPSMC/trunk/sources/lpair_2diss
cd lpair_2diss/cdf
sed -i "s@500000@$6@g" lpair.cxx
make
# preping input card:
label=${2}
cp ../../input.card ${label}.card
sed -i "s@xid@$3@g" ${label}.card
sed -i "s@xpt@${4}.0@g"   ${label}.card
# check if EOS area ready:
if [ ! -d "${1}/${2}" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${1}/${2}
fi
# run:
cp ${label}.card lpair.dat
./clpair < lpair.dat > ${label}.txt
mv events.lhe ${label}.lhe
# storing single file because cdf version does not have seed entry in input card:
xrdcp -fs ${label}.lhe ${7}/${1}/${2}/${label}.lhe
xrdcp -fs ${label}.card ${7}/${1}/${2}/${label}.card
xrdcp -fs ${label}.txt ${7}/${1}/${2}/${label}.txt
# clean working node:
cd ../..
rm -rf lpair_2diss/
