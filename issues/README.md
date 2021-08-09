# Known issues

## SuperCHIC event generator
Fragments for CMSSW simulation of SuperCHIC event generator samples due to incompatibility with hadronization in PYTHIA8:

         |    100   Abort from Pythia::next: parton+hadronLevel failed; giving up
         |  10000   Error in BeamRemnants::setKinematics: no momentum left for beam remnants
         |   1000   Error in Pythia::next: partonLevel failed; try again

The fragments are meant to v2, and latest v4 with and without photon-initiated lepton pair production.

## FPMC decay filter
File `fpmc_lhe.f` contains customized filters to collect distinct decay channels. Note that these filters are simply checking the outgoing particles to record the event or not in the output file. Hence, the desired number of produced events will depend on the branching fractions for the given decay channel. For instance, 3 million events may produce around 200 000 events in the leptonic decay channel.
