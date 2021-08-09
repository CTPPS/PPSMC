# Fragment for latest versions of SuperCHIC.

import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *

generator = cms.EDFilter("Pythia8HadronizerFilter",
    maxEventsToPrint = cms.untracked.int32(1),
    pythiaPylistVerbosity = cms.untracked.int32(1),
    filterEfficiency = cms.untracked.double(1.0),
    pythiaHepMCVerbosity = cms.untracked.bool(False),
    comEnergy = cms.double(13000.),
    PythiaParameters = cms.PSet(
        pythia8CommonSettingsBlock,
        pythia8CP5SettingsBlock,
        parameterSets = cms.vstring('pythia8CommonSettings',
                                    'pythia8CP5Settings',
                                    'keepProtonsIntact'
        ),
        keepProtonsIntact= cms.vstring(
                                    'LesHouches:matchInOut = off',
                                    'BeamRemnants:primordialKT = off',
                                    'PartonLevel:MPI = off',
                                    'PartonLevel:FSR = on',
                                    'SpaceShower:dipoleRecoil = on',
                                    'SpaceShower:pTmaxMatch = 2',
                                    'SpaceShower:QEDshowerByQ = off',
                                    'SpaceShower:pTdampMatch=1',
                                    'BeamRemnants:unresolvedHadron = 0'
                                    # 0 for double dissociation (dd)
                                    # 1 for single dissociation (sdb)
                                    # 2 for single dissociation (sda)
                                    # 3 for elastic (el)
        )
    )
)
