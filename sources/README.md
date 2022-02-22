# Monte Carlo generators sources

Repository of the Monte Carlo working group of PPS forward detector [twiki](https://twiki.cern.ch/twiki/bin/viewauth/CMS/CTppsMC).

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

## Sources

- LPAIR [repo](https://github.com/forthommel/lpair)
- FPMC [repo](https://github.com/fpmc-hep/fpmc)
- Herwig7 [site](https://herwig.hepforge.org/tutorials/index.html)
- Herwig++ [site](https://herwig.hepforge.org/versions.html)
- Herwig v6.5 [site](https://www.hep.phy.cam.ac.uk/theory/webber/Herwig/herwig65.html)
- ExHuMe [site](https://exhume.hepforge.org/)
- SuperCHIC [site](https://superchic.hepforge.org/)
- PYTHIA [site](http://home.thep.lu.se/~torbjorn/Pythia.html)
- ExDiff [site](https://exdiff.hepforge.org/)
- CepGen [site](https://cepgen.hepforge.org/)
