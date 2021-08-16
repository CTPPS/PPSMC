# PPSMC WG repo

Repository of the Monte Carlo working group of PPS forward detector [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/CTPPSMC).

**NOTE: to download a single file/folder, execute the following command:**

`svn checkout https://github.com/diemort/PPSMC/trunk/<file or folder>`

The shell scripts are intended to document and to organized the steps needed to setup and run the FPMC event generator and PPS simulation at LXPLUS machines.

One can simply run all steps from a given directory by choosing the necessary parameters for aparticular case, e.g. CMSSW release, entries in the fpmc input card and the cmsDriver input parameters.

## setup_fpmc.sh
Build and compile an working area for the FPMC event generator with a wrapper for hepMC output;

## setup_sim.sh
Build and compile a CMSSW environment including the PPS fast simulation customise, which includes a ED Filter to read the hepMC event sample;

:x:  **WARNING**: outdated version; more info at [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/TaggedProtonsPOGRecommendations).

:arrow_right:  Parameters: CMSSW release and architecture for a SCRAM-based project.

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

:arrow_right:  Parameters: CMSSW release, HepMC input file, and filename for output configuration.

## known issues
Generator files placed in the `issues` folder for specific case treatment.

### Private Production
The folder PrivProd contains the machinery needed to produce simulated private samples for Summer16, Fall17, and Autmn18 scenarios. Instructions listed the README file inside the folder.
