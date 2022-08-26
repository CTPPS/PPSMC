#!/bin/bash

# copy files to local node:
for i in `seq 0 $(( ${1} - 1 ))`;
do
    xrdcp -s $2/$3/$4/split/${4}_${i}.lhe ./${4}_${i}.lhe
done
# remove header:
for ((j=1; j<=${1}-1; j++));
do
    tail -n +86 ${4}_${j}.lhe > tmp_${j}.dat
    mv tmp_${j}.dat ${4}_${j}.lhe
done
# remove last line:
for ((j=0; j<=${1}-2; j++));
do
    sed -i '$ d' ${4}_${j}.lhe
done
# merge files:
if [ ! -f "${4}.lhe" ]; then
    for ((j=0; j<=${1}-1; j++));
    do
        cat ${4}_${j}.lhe >> ${4}.lhe
    done
fi
# transfer LHE to EOS area:
xrdcp -s ${4}.lhe $2/$3/${4}/${4}.lhe # FIXME remove this line to use xfer
cp $3/${4}/split/${4}_0.txt $3/${4}/${4}.txt
cp $3/${4}/split/${4}_0.card $3/${4}/${4}.card
# replace total number of events in card for bookkeeping:
evets=$(grep -c "<event>" ${4}_0.lhe)
files=$1
sed -i "/nev/s/$evets/$(( evets*files ))/g" $3/${4}/${4}.card
# clean EOS area of individual files (kept to facilitate upload in McMMCDB with split files):
#rm -rf $3/${4}/${4}_*
# clean working node
rm -rf *.lhe
