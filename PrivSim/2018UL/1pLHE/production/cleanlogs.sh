#!/bin/bash

rm -rf condor.dag.*
rm -rf condor_local.dag.*
for i in `ls err/`;
do
    rm -rf err/${i}/*
done

