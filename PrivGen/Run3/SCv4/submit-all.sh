#!/bin/bash

# define the output path for the generated files:
# e.g. /eos/cms/store/group/phys_pps/MC/requests_2022run3/
OUTPUTAREA=""

for i in `ls -d */`;
do
    # confirm a output path has been defined:
    if [-z "$OUTPUTAREA"]; then
        echo "Error: define an output area."
        exit 1
    fi
    # visit each folder and prep/submit dag:
    cd $i
    sed -i "/PROCLABEL/s/^/#/g" SCv4-${i}.dag
    sed -i "/xoutput/s/^#//g" SCv4-${i}.dag
    sed -i "s@xoutput@$OUTPUTAREA@g" SCv4-${i}.dag
    csg $i.dag
    cd ..
done

exit 1

condor_submit_dag Dijets-bbbar_sfact0/SCv4-Dijets-bbbar_sfact0.sub
condor_submit_dag Dijets-bbbar_sfact4/SCv4-Dijets-bbbar_sfact4.sub
condor_submit_dag Dijets-ccbar_sfact0/SCv4-Dijets-bbbar_sfact0.sub
condor_submit_dag Dijets-ccbar_sfact4/SCv4-Dijets-bbbar_sfact4.sub
condor_submit_dag Dijets-gg_sfact0/SCv4-Dijets-gg_sfact0.sub
condor_submit_dag Dijets-gg_sfact4/SCv4-Dijets-gg_sfact4.sub
condor_submit_dag Dijets-qqbar_sfact0/SCv4-Dijets-qqbar_sfact0.sub
condor_submit_dag Dijets-qqbar_sfact4/SCv4-Dijets-qqbar_sfact4.sub
condor_submit_dag GamGamEE-dd/SCv4-GamGamEE-dd.sub
condor_submit_dag GamGamEE-el/SCv4-GamGamEE-el.sub
condor_submit_dag GamGamEE-sd/SCv4-GamGamEE-sd.sub
condor_submit_dag GamGamMuMu-dd/SCv4-GamGamMuMu-dd.sub
condor_submit_dag GamGamMuMu-el/SCv4-GamGamMuMu-el.sub
condor_submit_dag GamGamMuMu-sd/SCv4-GamGamMuMu-sd.sub
condor_submit_dag GamGamTauTau-dd/SCv4-GamGamTauTau-dd.sub
condor_submit_dag GamGamTauTau-el/SCv4-GamGamTauTau-el.sub
condor_submit_dag GamGamTauTau-sd/SCv4-GamGamTauTau-sd.sub
condor_submit_dag GamGamWW-dd/SCv4-GamGamWW-dd.sub
condor_submit_dag GamGamWW-el/SCv4-GamGamWW-el.sub
condor_submit_dag GamGamWW-sd/SCv4-GamGamWW-sd.sub
