#!/bin/bash:

# mapping arguments:
split=$1
eosroot=$2
eosarea=$3
proc=$4
# copy files to local node:
for i in `seq 0 $(( ${split} - 1 ))`;
do
    xrdcp -s ${eosroot}/${eosarea}/${proc}/split/${proc}_${i}.lhe.xz ./${proc}_${i}.lhe.xz
    xz -d ${proc}_${i}.lhe.xz
done
# remove header:
for ((j=1; j<=${split}-1; j++));
do
    tail -n +86 ${proc}_${j}.lhe > tmp_${j}.dat
    mv tmp_${j}.dat ${proc}_${j}.lhe
done
# remove last line:
for ((j=0; j<=${split}-2; j++));
do
    sed -i '$ d' ${proc}_${j}.lhe
done
# merge files:
if [ ! -f "${proc}.lhe" ]; then
    for ((j=0; j<=${split}-1; j++));
    do
        cat ${proc}_${j}.lhe >> ${proc}.lhe
    done
fi
# transfer LHE to EOS area:
xz ${proc}.lhe
if ! xz -tvv ${proc}.lhe.xz &> /dev/null; then
    exit 1
fi
xrdcp -f ${proc}.lhe.xz ${eosroot}/${eosarea}/${proc}/${proc}.lhe.xz
cp ${eosarea}/${proc}/split/${proc}_0.txt ${eosarea}/${proc}/${proc}.txt
cp ${eosarea}/${proc}/split/${proc}_0.card ${eosarea}/${proc}/${proc}.card
# replace total number of events in card for bookkeeping:
evts=$(grep -c "<event>" ${proc}_0.lhe)
files=$split
sed -i "/nev/s/$evts/$(( evts*files ))/g" ${eosarea}/${proc}/${proc}.card
# clean working node:
rm -rf *.lhe.xz
rm -rf *.lhe
rm -rf `whoami`.cc
