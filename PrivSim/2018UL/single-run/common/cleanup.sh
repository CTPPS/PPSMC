#!/bin/bash

eosarea=$1
prodname=$2

echo "Cleaning pLHE step"
rm -rf ${eosarea}/${prodname}/pLHE/* && echo "OK" || echo "ERROR"
echo "Cleaning GEN step"
rm -rf ${eosarea}/${prodname}/GEN/* && echo "OK" || echo "ERROR"
echo "Cleaning SIM step"
rm -rf ${eosarea}/${prodname}/SIM/* && echo "OK" || echo "ERROR"
echo "Cleaning DR step"
rm -rf ${eosarea}/${prodname}/DRPremix/* && echo "OK" || echo "ERROR"
echo "Cleaning HLT step"
rm -rf ${eosarea}/${prodname}/HLT/* && echo "OK" || echo "ERROR"
echo "Cleaning RECO step"
rm -rf ${eosarea}/${prodname}/RECO/* && echo "OK" || echo "ERROR"
echo "Cleaning complete"
