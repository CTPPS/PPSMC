# PPSMC WG repo

Repository of the Monte Carlo working group of PPS forward detector [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/CTPPSMC).

**NOTE: to download a single folder, execute the following command:**

`svn checkout https://github.com/diemort/PPSMC/trunk/<folder>`

The shell scripts are intended to document and to organized the steps needed to setup and run the FPMC event generator and PPS simulation at LXPLUS machines.

One can simply run all steps from a given directory by choosing the necessary parameters for aparticular case, e.g. CMSSW release, entries in the fpmc input card and the cmsDriver input parameters.

## setup_fpmc.sh
Build and compile an working area for the FPMC event generator with a wrapper for hepMC output;

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
