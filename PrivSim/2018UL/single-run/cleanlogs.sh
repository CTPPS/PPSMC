#!/bin/bash

# clean error logs:
rm -rf ${1}/err/LHE/*
rm -rf ${1}/err/merge/*
rm -rf ${1}/err/pLHE/*
rm -rf ${1}/err/GEN/*
rm -rf ${1}/err/SIM/*
rm -rf ${1}/err/DR/*
rm -rf ${1}/err/RECO/*
rm -rf ${1}/err/HLT/*
rm -rf ${1}/err/MINI/*
# clean dag logs:
rm -rf *.dag.*
