#!/bin/bash

# clean error logs:
rm -rf err/gen/*
rm -rf err/delphes/*
# clean outputs:
rm -rf out/gen/*
rm -rf out/delphes/*
# clean condor logs:
rm -rf log/gen/*
rm -rf log/delphes/*
# clean dag logs:
rm -rf *.dag.*
