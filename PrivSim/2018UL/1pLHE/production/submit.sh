#!/bin/bash

jobname=FPMC_WW_13TeV_a0w_0E0_aCw_5E-7_SemiDecay_pt0

# create folder for err:
mkdir -p err/${jobname}

# add info to condor DAG:
cp condor.dag condor_local.dag
sed -i "s@xjobname@$jobname@g" condor_local.dag

# submit condor jobs:
condor_submit_dag condor_local.dag
