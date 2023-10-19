#!/bin/bash

# mapping arguments:
split=$1
eosroot=$2
eosarea=$3
tag=$4
# copy files to local node:
for i in `seq 0 $(( ${split} - 1 ))`;
do
    xrdcp -s ${eosroot}/${eosarea}/${tag}/LHE/split/${tag}_${i}.lhe.xz ./${tag}_${i}.lhe.xz
    xz -d ${tag}_${i}.lhe.xz
done
# remove header:
for ((j=1; j<=${split}-1; j++));
do
    tail -n +86 ${tag}_${j}.lhe > tmp_${j}.dat
    mv tmp_${j}.dat ${tag}_${j}.lhe
done
# remove last line:
for ((j=0; j<=${split}-2; j++));
do
    sed -i '$ d' ${tag}_${j}.lhe
done
# merge files:
if [ ! -f "${tag}.lhe" ]; then
    for ((j=0; j<=${split}-1; j++));
    do
        cat ${tag}_${j}.lhe >> ${tag}.lhe
    done
fi
# transfer LHE to EOS area:
xz ${tag}.lhe
if ! xz -tvv ${tag}.lhe.xz &> /dev/null; then
    exit 1
fi
xrdcp -f ${tag}.lhe.xz ${eosroot}/${eosarea}/${tag}/LHE/${tag}.lhe.xz
cp ${eosarea}/${tag}/LHE/split/${tag}_0.txt ${eosarea}/${tag}/${tag}.txt
cp ${eosarea}/${tag}/LHE/split/${tag}_0.card ${eosarea}/${tag}/${tag}.card
# replace total number of events in card for bookkeeping:
evts=$(grep -c "<event>" ${tag}_0.lhe)
files=$split
sed -i "/nev/s/$evts/$(( evts*files ))/g" ${eosarea}/${tag}/LHE/${tag}.card
# clean working node
rm -rf *.lhe.xz
rm -rf *.lhe
rm -rf `whoami`.cc
