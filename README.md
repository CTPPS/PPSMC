# CTPPSMC
Repository of the Monte Carlo working group of CT-PPS

The shell scripts are intended to document and to organized the steps needed to setup and run the FPMC event generator and CT-PPS simulation at LXPLUS machines.

One can simply run all steps from a given directory by choosing the necessary parameters for a particular case, e.g., CMSSW release, entries in the fpmc input card and the cmsDriver input parameters.

# setup_fpmc.sh
Build and compile an working area for the FPMC event generator with a wrapper for hepMC output;

# setup_sim.sh
Build and compile a CMSSW environment including the CT-PPS fast simulation customise, which includes a ED Filter to read the hepMC event sample;

-- Parameters: CMSSW release and architecture for a SCRAM-based project.

# run_fpmc.sh
Setup and run a FPMC instance with minimal parameters:

        --cfg Datacards/dataQED_WW \
        --comenergy 13000 \
        --fileout dataWW.hepmc \
        --nevents 10

Other parameters can be added folliwng the instructions in the FPMC manual: https://arxiv.org/pdf/1102.2531.pdf

# run_sim.sh
Setup and run the CT-PPS fast simulation taking the produced event sample from fpmc working dir. Usual cmsDriver parameters are set plus a filter to specify the decay channel.

It propagates the hepMC input file to the ED Filter meant to be simulated for detector effects.

-- Parameters: CMSSW release, hepMC input file, and filename for output configuration.
