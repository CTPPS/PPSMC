# PPSMC WG repo

Repository of the Monte Carlo working group of PPS forward detector [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/CTppsMC).

**NOTE: to download a single folder, execute the following command:**

`svn checkout https://github.com/diemort/PPSMC/trunk/<folder>`

The shell scripts are intended to document and to organized the steps needed to setup and run the FPMC event generator and PPS simulation at LXPLUS machines.

One can simply run all steps from a given directory by choosing the necessary parameters for aparticular case, e.g. CMSSW release, entries in the fpmc input card and the cmsDriver input parameters.

## known issues
Generator files placed in the `issues` folder for specific case treatment.

### Private Production
The folder PrivProd contains the machinery needed to produce simulated private samples for Summer16, Fall17, and Autmn18 scenarios. Instructions listed the README file inside the folder.
