#!/bin/bash

# clean error logs:
rm -rf err/gen/*
rm -rf err/merge/*
rm -rf err/mcdb/*
# clean outputs:
rm -rf out/gen/*
rm -rf out/merge/*
rm -rf out/mcdb/*
# clean condor logs:
rm -rf log/gen/*
rm -rf log/merge/*
rm -rf log/mcdb/*
# clean dag logs:
rm -rf *.dag.*
