#!/bin/bash

# clean error logs:
rm -rf err/gen/*
rm -rf err/splitter/*
rm -rf err/mcdb/*
# clean outputs:
rm -rf out/gen/*
rm -rf out/splitter/*
rm -rf out/mcdb/*
# clean condor logs:
rm -rf log/gen/*
rm -rf log/splitter/*
rm -rf log/mcdb/*
# clean dag logs:
rm -rf *.dag.*
