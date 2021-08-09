# PPSMC WG repo

Repository of the Monte Carlo working group of PPS forward detector [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/CTPPSMC).

The shell scripts are intended to document and to organized the steps needed to setup and run the FPMC event generator and PPS simulation at LXPLUS machines.

One can simply run all steps from a given directory by choosing the necessary parameters for aparticular case, e.g. CMSSW release, entries in the fpmc input card and the cmsDriver input parameters.

## setup_fpmc.sh
Build and compile an working area for the FPMC event generator with a wrapper for hepMC output;

## setup_sim.sh
Build and compile a CMSSW environment including the PPS fast simulation customise, which includes a ED Filter to read the hepMC event sample;
:x: **WARNING**: outdated version; more info at [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/TaggedProtonsPOGRecommendations).

:arrow_right: Parameters: CMSSW release and architecture for a SCRAM-based project.

## run_fpmc.sh
Setup and run a FPMC instance with minimal parameters for HepMC output:

```
        --cfg Datacards/dataQED_WW \
        --comenergy 13000 \
        --fileout dataWW.hepmc \
        --nevents 10
```

Other parameters can be added folliwng the instructions in the FPMC [manual](https://arxiv.org/pdf/1102.2531.pdf).

Directives for LHE output given in the bash macro.

## run_sim.sh
Setup and run the PPS fast simulation taking the produced event sample from fpmc working dir. Usual cmsDriver parameters are set plus a filter to specify the decay channel.

It propagates the hepMC input file to the ED Filter meant to be simulated for detector effects.

:arrow_right: Parameters: CMSSW release, HepMC input file, and filename for output configuration.

## known issues

### SuperCHIC event generator
Fragments for CMSSW simulation of SuperCHIC event generator samples due to incompatibility with hadronization in PYTHIA8:

         |    100   Abort from Pythia::next: parton+hadronLevel failed; giving up
         |  10000   Error in BeamRemnants::setKinematics: no momentum left for beam remnants
         |   1000   Error in Pythia::next: partonLevel failed; try again

The fragments are meant to v2, and latest v4 with and without photon-initiated lepton pair production.

### FPMC decay filter
File `fpmc_lhe.f` contains customized filters to collect distinct decay channels. Note that these filters are simply checking the outgoing particles to record the event or not in the output file. Hence, the desired number of produced events will depend on the branching fractions for the given decay channel. For instance, 3 million events may produce around 200 000 events in the leptonic decay channel.

### Private Production
The folder PrivProd contains the machinery needed to produce simulated private samples for Summer16, Fall17, and Autmn18 scenarios. For all years, the set of files consist of:

- `config.py`: CMSSW configuration file;
- `submitter\*`: Bash macro to split the production in a certain numbers of jobs;
- `script.sh`: Bash macro for LXBATCH job run;
- `condor.sub`: HTCondor script to submit jobs.

The command line directive is:

`./submitter\* [tag] [job_name]`
(`./submitter_pLHEtoGENSIM.sh FPMC_WW_bSM_13tev_a0w_0_aCw_8e-6_lept_pt0 GS17_WW_0_8_lept`)

where [tag] defines the folder names for the output files and the tag to be used in the next steps for automate job submission and [job_name] the HTCondor job label.

**Instructions**:

- By default, all input/output files are set to the PPS EOS area. Change the paths accordingly to your needs.

- All submitter macros have the line `exit 1` uncommented, which produced the set of files needed for the simulation, but avoid submitting jobs. Comment that line to submit the jobs.

- The DRPremix step requires a GRID certificate to be placed at `~/private` with permission 774.

- Be aware that the template for the DRPremix config file has 27MB, which will be duplicated to the number of jobs required by the user. In the case of 100 jobs, the DRPremix setup will expand to almost 3GB of disk space.

- MINIAOD step is provided for 2017 only; if needed for other years please contact the coordinator.

- Given a past experience with FPMC, a certain number of unknown problematic events had to be removed in the GENSIM step. The corresponding scripts are placed at the folder named `to_extract_bad_events`. Use these files only if specific events have to be removed from the simulation.
