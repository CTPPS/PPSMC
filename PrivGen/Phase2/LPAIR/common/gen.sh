#!/bin/bash

# sourcing CERN LCG 101 to compile LPAIR with latest ROOT:
source /cvmfs/sft.cern.ch/lcg/views/setupViews.sh LCG_101 x86_64-centos7-gcc8-opt
# installing mc generator:
if [ $coll='dd' ];
then
    svn checkout https://github.com/diemort/PPSMC/trunk/sources/lpair_2diss
    cd lpair_2diss/cdf
    sed -i "s@500000@$6@g" lpair.cxx
else
    git clone https://github.com/forthommel/lpair.git
    cd lpair/desy
fi
make
# mapping arguments:
eosarea=$1
label=$2
pid=$3
coll=$4
if [ $coll='el' ];
then
    scatt1=2
    scatt2=2
elif [ $coll='sd' ];
then
    scatt1=11
    scatt2=2
elif [ $coll='dd' ];
then
    scatt1=11
    scatt2=11
fi
ptcut=$5
it=$6
evts=$7
eosroot=$8
# preping input card:
if [ $coll='dd' ];
then
    cp ../../input-cdf.card ${label}.card
else
    cp ../../input-desy.card ${label}.card
fi
sed -i "s@xproc@$label@g" ${label}.card
sed -i "s@xid@$pid@g" ${label}.card
sed -i "s@xscatt1@$scatt1@g" ${label}.card
sed -i "s@xscatt2@$scatt2@g" ${label}.card
if [ $coll='dd' ];
then
    sed -i "s@xpt@${ptcut}.0@g" ${label}.card
else
    sed -i "s@xpt@${ptcut}@g" ${label}.card
fi

sed -i "s@xevt@$evts@g" ${label}.card
# check if EOS area ready:
if [ ! -d "${eosarea}/${label}" ];
then
    xrdfs eoscms.cern.ch mkdir -p ${eosarea}/${label}
fi
# run:
if [ $coll='dd' ];
then
    cp ${label}.card lpair.dat
    ./clpair < lpair.dat > ${label}.txt
    mv events.lhe ${label}.lhe
else
    cp ${label}.card lpair.card
    ./lpair < lpair.card > ${label}.txt
    root -q -b 'ConvertLPairToLHE.C("events.root","'${label}.lhe'",'$evts',0)'
fi
# compress output:
xz ${label}.lhe
if ! xz -tvv ${label}.lhe.xz &> /dev/null; then
    echo "Corrupted .lhe.xz file -- Exiting."
    exit 1
fi
# transfer files to EOS:
xrdcp -f ${label}.lhe.xz ${eosroot}/${eosarea}/${label}/${label}.lhe.xz
xrdcp -f ${label}.card ${eosroot}/${eosarea}/${label}/${label}.card
xrdcp -f ${label}.txt ${eosroot}/${eosarea}/${label}/${label}.txt
# clean workind node
cd ../..
rm -rf lpair/
rm -rf `whoami`.cc
