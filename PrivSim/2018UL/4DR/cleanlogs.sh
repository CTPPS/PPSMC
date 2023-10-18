#!/bin/bash

rm -rf condor.dag.*
for i in `ls err/`;
do
    rm -rf err/${i}/*
done

