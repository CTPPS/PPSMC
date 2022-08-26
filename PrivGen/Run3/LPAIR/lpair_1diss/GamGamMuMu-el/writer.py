#!/usr/bin/env cmsRun
import FWCore.ParameterSet.Config as cms

process = cms.Process("Writer")

import sys
for arg in sys.argv[2:]:
	opt = arg[0:arg.find("=")]
	if opt=="numevents":
		numevents = int(arg[arg.find("=")+1:])
	if opt=="first_event":
		first_event = int(arg[arg.find("=")+1:])

process.load('FWCore.MessageService.MessageLogger_cfi')
process.MessageLogger.cerr.FwkReport.reportEvery = 10000


process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(numevents))

process.source = cms.Source("PoolSource",
     fileNames = cms.untracked.vstring('file:pLHE.root'),
     skipEvents = cms.untracked.uint32(first_event)
)

process.load("FWCore.MessageService.MessageLogger_cfi")
process.MessageLogger.cerr.threshold = 'INFO'

process.writer = cms.EDAnalyzer("LHEWriter")

process.outpath = cms.EndPath(process.writer)

